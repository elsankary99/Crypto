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
    @Published var searchField:String = ""
    
    private let dataService = CoinDataService()
    var anyCancelable = Set<AnyCancellable>()
    
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        $searchField
            .combineLatest( dataService.$allCoins)
            .map({ (text, startingCoins) -> [CoinModel]  in
                guard !text.isEmpty else {
                    return startingCoins
                }
                let searchText = text.lowercased()
              return startingCoins.filter { coin in
                  return coin.name.lowercased().contains(searchText) ||
                    coin.symbol.lowercased().contains(searchText) ||
                    coin.id.lowercased().contains(searchText)
                    
                }
            })
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &anyCancelable)
             
    }
}
