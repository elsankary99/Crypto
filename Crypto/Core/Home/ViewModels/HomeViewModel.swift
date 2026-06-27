//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 23/06/2026.
//

import Foundation
import Combine
internal import UIKit

class HomeViewModel:ObservableObject {
    @Published var statistics:[StatisticModel] = []
    @Published var allCoins:[CoinModel] = []
    @Published var portofolioCoins:[CoinModel] = []
    @Published var searchText:String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    var anyCancelable = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, hldingsReversed, price, priceReversed
    }
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        // Update allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &anyCancelable)
        
      // Update PortfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$portfolioEntities)
            .map (mapAllCoinsToPortfolioCoin)
            .sink { [weak self] returnedCoins in
                guard let self = self else {return}
                self.portofolioCoins = self.sortPortfolioCoinIfNeeded(coin: returnedCoins)
                
            }
            .store(in: &anyCancelable)
        
        // Update MarketData
        marketDataService.$marketData
            .combineLatest($portofolioCoins)
            .map (mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &anyCancelable)
        
        
             
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData (){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticGenerator.notification(type: .success)
    }
    
    func  filterAndSortCoins(text : String , startingCoins : [CoinModel] , sortOption: SortOption ) ->[CoinModel] {
        var filteredCoins = filterCoins(text: text, startingCoins: startingCoins)
            sortCoins(sortOption: sortOption, coin: &filteredCoins)
        return filteredCoins
    }
    
    func filterCoins( text : String , startingCoins : [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return startingCoins
        }
        let searchText = text.lowercased()
      return startingCoins.filter { coin in
          return coin.name.lowercased().contains(searchText) ||
            coin.symbol.lowercased().contains(searchText) ||
            coin.id.lowercased().contains(searchText)
            
        }
    }
    
    func sortCoins (sortOption: SortOption, coin: inout [CoinModel] ) {
        switch sortOption {
        case .rank, .holdings, .hldingsReversed:
              coin.sort(by: {$0.rank < $1.rank})
        case .rankReversed:
              coin.sort(by: {$0.rank > $1.rank})
        case .price:
              coin.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
              coin.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    func sortPortfolioCoinIfNeeded(coin: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coin.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .hldingsReversed:
            return coin.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coin
        }
    }
    
    func mapAllCoinsToPortfolioCoin(allCoins:[CoinModel], portfolioEntities:[PortfolioEntity])-> [CoinModel] {
        allCoins
             .compactMap { (coin) -> CoinModel? in
                 guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                     return nil
                 }
                 return coin.updateHoldings(amount: entity.amount)
             }
    }
    
    func mapGlobalMarketData(marketDataModel:MarketDataModel? ,portfolioCoins: [CoinModel]) -> [StatisticModel] {
        
     var stats:[StatisticModel] = []
        
        guard let data =  marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volum", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map ({ coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.currentHoldingsValue / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            })
        let previousValueReduce = previousValue.reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValueReduce) / previousValueReduce) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value:portfolioValue.asCurrencyWith2Decimals(),percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap,volume,btcDominance,portfolio])
        
        return stats
    }
}
