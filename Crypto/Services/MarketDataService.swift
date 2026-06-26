//
//  MarketDataService.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 25/06/2026.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData:MarketDataModel? = nil
    private var anyCancellable:AnyCancellable?
   
    init(){
        getMarketData()
    }
    
    func getMarketData (){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        anyCancellable = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompeletion)
            { [weak self] returnedData in
                guard let self = self else {return}
                self.marketData = returnedData.data
                self.anyCancellable?.cancel()
            }
    }
}
