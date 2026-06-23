//
//  CryptoApp.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 20/06/2026.
//

import SwiftUI

@main
struct CryptoApp: App {
@StateObject var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
                
        }
    }
}
