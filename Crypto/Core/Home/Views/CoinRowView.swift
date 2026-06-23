//
//  CoinRowView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 23/06/2026.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin:CoinModel
    let showHoaldingColumn:Bool
    
    var body: some View {
        HStack (spacing:0){
            leftColumn
            Spacer()
            if showHoaldingColumn {
              centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
        CoinRowView(coin: DeveloperPreview.instance.coin,showHoaldingColumn: true)
        
//        CoinRowView(coin: DeveloperPreview.instance.coin,showHoaldingColumn: true)
//            .preferredColorScheme(.dark)


}


extension CoinRowView {
    
    var leftColumn:some View {
        HStack (spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30,height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .padding(.leading, 6)
        }
    }
    
    var centerColumn:some View {
        VStack (alignment:.trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
            Text((coin.priceChangePercentage24H ?? 0).asPercentString())
             
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    var rightColumn:some View {
        VStack (alignment:.trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            Text((coin.priceChangePercentage24H ?? 0).asPercentString())
                .foregroundStyle(
                   (coin.priceChangePercentage24H ?? 0)  >= 0 ?
                    Color.theme.green :
                    Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3,alignment:.trailing )
    }
}
