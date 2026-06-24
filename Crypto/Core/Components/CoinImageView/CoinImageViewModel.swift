//
//  CoinImageViewModel.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 24/06/2026.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel:ObservableObject {
    
    @Published var image:UIImage? = nil
    @Published var isLoading:Bool = false

    private let coin:CoinModel
    private let service:CoinImageService
    private var anyCancellable = Set<AnyCancellable>()
    
    init(coin:CoinModel){
        self.coin = coin
        self.service = CoinImageService(coin: coin)
        self.addSubscriber()
        isLoading = true
    }
    
    private func addSubscriber(){
 

        service.$coinImage
            .sink(receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.isLoading = false
            })
  
 
            .store(in: &anyCancellable)
    }
    
}
