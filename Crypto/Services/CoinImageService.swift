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
    private let fileManager = LocaleFileManager.instance
    private let folderName = "coin_images"
    
    init(coin:CoinModel){
        self.coin = coin
        getCoinImage()
    }
    
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName){
            coinImage = savedImage
            print("🗂️")
        } else {
            downloadCoinImage()
            print("🛜")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else {return}
        NetworkingManager.download(url: url)
            .tryMap { imageData -> UIImage? in
                return UIImage(data:imageData )
            }
        
            .sink(receiveCompletion: NetworkingManager.handleCompeletion(compeletion:),   receiveValue: { [weak self] returnedImage in
               guard let self = self ,
                     let image = returnedImage else {return}
                self.coinImage = image
                self.fileManager.saveImage(image: image, imageName: self.coin.id, folderName: folderName)
            })
        
            .store(in: &anyCancellable)

    }
}
