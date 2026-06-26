//
//  portfolioCoinView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 25/06/2026.
//

import SwiftUI

struct portfolioCoinView: View {
    let coin:CoinModel
    var body: some View {
        VStack{
            CoinImageView(coin: coin)
                .frame(width: 50,height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
    }
}

#Preview {
    portfolioCoinView(coin: DeveloperPreview.instance.coin)
}
