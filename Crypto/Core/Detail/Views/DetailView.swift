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
    init(coin: CoinModel){
        print("INIT SETAIL VIEW")
         _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ScrollView {
            VStack (spacing:20){
                Text("")
                    .frame(height: 150)
                
                Text("OverView")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.theme.accent)
                    .frame(maxWidth: .infinity,alignment: .leading)
                Divider()
                
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          spacing: 30,
                          pinnedViews: []) {
                    ForEach(vm.overviewStatstics) { stat in
                        StatisticView(stat: stat)
                    }
                }
                
                Text("Additional Details")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.theme.accent)
                    .frame(maxWidth: .infinity,alignment: .leading)
                Divider()
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          spacing: 30,
                          pinnedViews: []) {
                    ForEach(vm.additionalStatstics) { stat in
                        StatisticView(stat: stat)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Bitcoin")
    }
}

#Preview {
    NavigationStack{
        DetailView(coin: DeveloperPreview.instance.coin )
    }
}
