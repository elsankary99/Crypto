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
        
        anyCancellable =  URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .receive(on: DispatchQueue.main)
            .tryMap { output -> Data in
              guard  let response = output.response as? HTTPURLResponse,
                     response.statusCode >= 200 && response.statusCode < 300 else
                {
                  throw URLError(.badServerResponse)
              }
                return output.data
            }
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { compeletion in
                switch compeletion {
                case .finished:
                    break
                case .failure(let error):
                    print("ERROR :\(error)")
                }
            } receiveValue: { [weak self] returnedCoins in
                guard let self = self else {return}
                self.allCoins = returnedCoins
                self.anyCancellable?.cancel()
            }

    }
}
