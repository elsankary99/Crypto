//
//  SearchBarView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 24/06/2026.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText:String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
                
            TextField("search by name or symbol...", text: $searchText)
                .autocorrectionDisabled(true)
                .overlay(alignment: .trailing, content: {
                        Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x:10)
                        .foregroundStyle( Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1)
                        .onTapGesture {
                              UIApplication.shared.endEditing()
                              searchText = ""
                            }
                })
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.3),radius: 10)
        
        )
        .padding()
        
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
