//
//  DetailView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 27/06/2026.
//

import SwiftUI

struct DetailLoadingView:View {
    @Binding var coin:CoinModel?
     
     init(coin: Binding<CoinModel?>){
         print("INIT SETAIL VIEW")
         self._coin = coin
     }
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject var vm:DetailViewModel
    private let columns:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var showAllDescription: Bool = false

    init(coin: CoinModel){
        print("INIT SETAIL VIEW")
         _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ScrollView {
            VStack{
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack (spacing:20){
                    overviewTitle
                    Divider()
                    descriptionSection
                    .frame(maxWidth: .infinity,alignment: .leading)
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                    
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
              navigationBarTrailingItems
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }
}

#Preview {
    NavigationStack{
        DetailView(coin: DeveloperPreview.instance.coin )
    }
}


extension DetailView {
    var overviewTitle : some View {
        Text("OverView")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: 30,
                  pinnedViews: []) {
            ForEach(vm.overviewStatstics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    var additionalTitle : some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: 30,
                  pinnedViews: []) {
            ForEach(vm.additionalStatstics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    var navigationBarTrailingItems:some View {
        HStack {
            Text (vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
            
            
        }
    }
    
    var descriptionSection: some View {
        VStack(alignment: .leading){
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty {
                Text(coinDescription)
                    .lineLimit(showAllDescription ? nil : 3)
                    .multilineTextAlignment(.leading)
                    .font(.callout)
                    .foregroundStyle(Color.theme.secondaryText)
                
                Button(showAllDescription ? "Less" :"Show More..") {
                    withAnimation(.easeInOut
                    ) {
                        showAllDescription.toggle()
                    }
                }
                .font(.caption)
                .bold()
                .tint(.blue)
            }
          
            
        }
    }
    
    var websiteSection: some View {
        VStack (alignment: .leading){
            if let websiteURL = vm.websiteURL,
               let url = URL(string: websiteURL){
                Link("Website", destination: url)
            }
            
            if let redditURL = vm.redditURL,
               let url = URL(string: redditURL){
                Link("Reddit", destination: url)
            }

        }
        .tint(.blue)
        .bold()
        .font(.headline)
        .frame(maxWidth: .infinity,alignment: .leading)

    }
}
