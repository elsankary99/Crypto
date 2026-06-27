//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 27/06/2026.
//

import Foundation
import Combine
class DetailViewModel: ObservableObject {
    
    @Published var overviewStatstics: [StatisticModel] = []
    @Published var additionalStatstics: [StatisticModel] = []
    @Published var coin: CoinModel

    private let coinDetailDataService :CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel){
        self.coin = coin
        coinDetailDataService  = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetail
            .combineLatest($coin)
            .map(mapToStatistic)
            .sink { [weak self] returnCoinDetail in
                guard let self = self else {return}
                
                self.overviewStatstics = returnCoinDetail.overview
                self.additionalStatstics = returnCoinDetail.additional
            }
            .store(in: &cancellables)
    }
    
    func mapToStatistic (coinDetailModel:CoinDetailModel?, coinModel:CoinModel) -> (overview: [StatisticModel], additional:[StatisticModel]) {
       let overviewArray = createOverviewArray(coinModel: coinModel)
       let additionalArray = createadditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        return (overviewArray, additionalArray)
    }
    
    
    func createOverviewArray (coinModel:CoinModel) ->[StatisticModel] {
        // overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let priceChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price , percentageChange: priceChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let valueState = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray : [StatisticModel] = [ priceStat, marketCapStat, rankStat, valueState ]
        
        return overviewArray
    }
    
    func createadditionalArray (coinDetailModel:CoinDetailModel?, coinModel:CoinModel) ->[StatisticModel] {
        //additional
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let additionalPriceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let additionalPricePercentageChange = coinModel.priceChangePercentage24H
        let additionalPriceStat = StatisticModel(title: "24h Price Change", value: additionalPriceChange, percentageChange: additionalPricePercentageChange)
        
        let additionalmarketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "" )
        let additionalMarketCapChange =  coinModel.marketCapChangePercentage24H
        let additionalMarketCapStat = StatisticModel(title: "24h Market Cap Changes", value: additionalmarketCapChange, percentageChange: additionalMarketCapChange)
    
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray : [StatisticModel] = [highStat, lowStat, additionalPriceStat, additionalMarketCapStat, blockStat, hashingStat ]
        return additionalArray
    }
    
}
