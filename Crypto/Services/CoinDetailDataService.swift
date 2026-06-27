//
//  CoinDetailDataService.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 27/06/2026.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetail:CoinDetailModel? = nil
    
    private var coinDetailCancellable:AnyCancellable?
    let coin: CoinModel

    init(coin: CoinModel){
        self.coin = coin
        getCoinDetail()
    }
    
    func getCoinDetail() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        
        coinDetailCancellable = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompeletion) { [weak self] returnedCoinDetail in
                guard let self = self else {return}
                self.coinDetail = returnedCoinDetail
                self.coinDetailCancellable?.cancel()
            }
    }
}
