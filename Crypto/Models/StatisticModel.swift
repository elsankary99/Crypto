//
//  StatisticModel.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 25/06/2026.
//

import Foundation


struct StatisticModel : Identifiable{
    let id : String = UUID().uuidString
    let title : String
    let value : String
    let percentageChange:Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
