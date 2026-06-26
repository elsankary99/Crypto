//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 23/06/2026.
//

import Foundation
import Combine

class HomeViewModel:ObservableObject {
    @Published var statistics:[StatisticModel] = []
    @Published var allCoins:[CoinModel] = []
    @Published var portofolioCoins:[CoinModel] = []
    @Published var searchField:String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    var anyCancelable = Set<AnyCancellable>()
    
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        // Update allCoins
        $searchField
            .combineLatest( coinDataService.$allCoins)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &anyCancelable)
        
        // Update MarketData
        marketDataService.$marketData
            .map (mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &anyCancelable)
        
        // Update PortfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$portfolioEntities)
            .map { (coinModel, portfolioEntity) -> [CoinModel] in
               coinModel
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntity.first(where: { $0.coinID == coin.id }) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
                 
            }
            .sink { [weak self] returnedCoins in
                self?.portofolioCoins = returnedCoins
                
            }
            .store(in: &anyCancelable)
             
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func filterCoins( text : String , startingCoins : [CoinModel] ) -> [CoinModel] {
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
    
    func mapGlobalMarketData(marketDataModel:MarketDataModel?) -> [StatisticModel] {
        
     var stats:[StatisticModel] = []
        
        guard let data =  marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volum", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00",percentageChange: 0)
        
        stats.append(contentsOf: [marketCap,volume,btcDominance,portfolio])
        
        return stats
    }
}
