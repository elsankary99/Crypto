//
//  CoinDataService.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 23/06/2026.
//

import Foundation
import Combine
class CoinDataService {
    
    @Published var allCoins:[CoinModel] = []
    var anyCancellable:AnyCancellable?
    init(){
        getCoins()
    }
    
    func getCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")else{return}
        
        anyCancellable = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompeletion,
                  receiveValue: { [weak self] returnedCoins in
                guard let self = self else {return}
                self.allCoins = returnedCoins
                self.anyCancellable?.cancel()
            }
            )

    }
}
