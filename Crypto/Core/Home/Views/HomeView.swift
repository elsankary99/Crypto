//
//  HomeView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 21/06/2026.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm:HomeViewModel
    @State private var showPortfolio:Bool = false
    @State private var showPortfolioSheet:Bool = false
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioSheet) {
                    PortfolioView()
                }
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchField)
                columnTitles
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))

                }
            
                if showPortfolio {
              portofolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    NavigationView {
         HomeView()
            .environmentObject(DeveloperPreview.instance.homeVM)
//            .toolbar(.hidden)
    }
   
}


extension HomeView {
    private var homeHeader:some View {
        HStack{
            CircleButtonView(imageName:showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .background(CircleButtonAnimation(animate: $showPortfolio))
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioSheet.toggle()
                    }
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" :"Live Prices")
                .foregroundStyle(Color.theme.accent)
                .font(.headline)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(imageName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0 ))
                .onTapGesture {
                    withAnimation {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal,6)
    }
    
    
    private var allCoinsList:some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoaldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 4))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    private var portofolioCoinsList:some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoaldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 4))
            }
        }
        .listStyle(PlainListStyle())
    }
    
   private var columnTitles:some View {
        HStack {
            Text("Coin").padding(.leading,15)
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3,alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
