//
//  CoinImageService.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 24/06/2026.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
    
    @Published var coinImage:UIImage? = nil
    
    
    private let coin:CoinModel
    private var anyCancellable = Set<AnyCancellable>()
    
    init(coin:CoinModel){
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage(){
        guard let url = URL(string: coin.image) else {return}
        NetworkingManager.download(url: url)
            .tryMap { imageData -> UIImage? in
                return UIImage(data:imageData )
            }
        
            .sink(receiveCompletion: NetworkingManager.handleCompeletion(compeletion:),   receiveValue: { [weak self] returnedImage in
                self?.coinImage = returnedImage
            })
        
            .store(in: &anyCancellable)

    }
}
