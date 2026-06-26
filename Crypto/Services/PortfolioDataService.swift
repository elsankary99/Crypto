//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 26/06/2026.
//

import Foundation
import Combine
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
       get()
    }
    
    
    // MARK: PUBLIC
    
    func updatePortfolio(coin: CoinModel , amount: Double){
        if let entity = portfolioEntities.first (where: {$0.coinID == coin.id}){
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
 
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE
    
   private func add(coin: CoinModel , amount: Double){
       let portfolio = PortfolioEntity(context: context)
        portfolio.coinID = coin.id
        portfolio.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity , amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
   private func get(){
      let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
        portfolioEntities = try context.fetch(request)
        } catch let error {
            print("Error Fetching Entities. \(error)")
        }
    }
    
    private func delete(entity:PortfolioEntity){
        context.delete(entity)
        applyChanges()
    }
    
    
    private func save(){
        do {
            try context.save()
        } catch let error {
            print("Error Saving Entity.\(error)")
        }
     }
    
    private func applyChanges(){
        save()
        get()
    }
    
}
