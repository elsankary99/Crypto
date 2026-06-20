//
//  CryptoApp.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 20/06/2026.
//

import SwiftUI
import CoreData

@main
struct CryptoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
