//
//  ContentView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 20/06/2026.
//

import SwiftUI

struct ContentView: View {
    
    
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStackLayout(spacing: 30){
                Text("Accent Color")
                    .foregroundStyle(Color.theme.accent)
                
                
                Text("Green Color")
                    .foregroundStyle(Color.theme.green)
                
                Text("Red Color")
                    .foregroundStyle(Color.theme.red)
                
                Text("Secondary Text Color")
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
    
    
    
}

#Preview {
    ContentView()
}
