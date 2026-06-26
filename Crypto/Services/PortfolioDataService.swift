//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 26/06/2026.
//

import Foundation
import CoreData


class PortfolioDataService {
    
    @Published var portfolioEntities:[PortfolioEntity] = []
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error Load Container : \(error)")
            }
        }
       context = container.viewContext
    }
    
    
    func addEntity(coin:CoinModel,amount:Double){
       let portfolio = PortfolioEntity(context: context)
        portfolio.coinID = coin.id
        portfolio.amount = amount
    }
}
