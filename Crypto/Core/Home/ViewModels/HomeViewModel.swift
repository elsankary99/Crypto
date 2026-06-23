//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 23/06/2026.
//

import Foundation
import Combine

class HomeViewModel:ObservableObject {
    
    @Published var allCoins:[CoinModel] = []
    @Published var portofolioCoins:[CoinModel] = []
    
    private let dataService = CoinDataService()
    var anyCancelable = Set<AnyCancellable>()
    
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        dataService.$allCoins
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &anyCancelable)
    }
}
