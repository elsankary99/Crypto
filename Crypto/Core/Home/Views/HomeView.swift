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
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailsView: Bool = false
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioSheet) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
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
        .navigationDestination(isPresented: $showDetailsView) {
                DetailLoadingView(coin: $selectedCoin)
        }
//        .background {
////            NavigationLink(destination:  DetailView(coin: selectedCoin), isActive: $showDetailsView, label: {EmptyView()})
//                .navigationDestination(isPresented: $showDetailsView) {
//                    if let coin = selectedCoin {
//                        DetailView(coin: selectedCoin)
//                    }
//                }
//        }
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
    
   private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailsView.toggle()
    }
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
                        .onTapGesture {
                            segue(coin: coin)
                        }
 
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    private var portofolioCoinsList:some View {
        List {
            ForEach(vm.portofolioCoins) { coin in
                CoinRowView(coin: coin, showHoaldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 4))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
   private var columnTitles:some View {
       HStack {
           HStack (spacing:4) {
               Text("Coin").padding(.leading,15)
               Image(systemName: "chevron.down")
                   .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1 : 0)
                   .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : -180))
               
           }
           .onTapGesture {
               withAnimation{
                   if vm.sortOption == .rank {
                       vm.sortOption = .rankReversed
                   } else {
                       vm.sortOption = .rank
                   }
               }
           }
           Spacer()
           if showPortfolio {
               HStack (spacing:4) {
                   Text("Holdings")
                   Image(systemName: "chevron.down")
                       .opacity(vm.sortOption == .holdings || vm.sortOption == .hldingsReversed ? 1 : 0)
                       .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : -180))
               }
               .onTapGesture {
                   withAnimation{
                       if vm.sortOption == .holdings {
                           vm.sortOption = .hldingsReversed
                       } else {
                           vm.sortOption = .holdings
                       }
                   }
               }
               
           }
           
           HStack (spacing:4) {
               Text("Price")
               Image(systemName: "chevron.down")
                   .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1 : 0)
                   .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : -180))
               
           }
           .onTapGesture {
            withAnimation{
               vm.sortOption =  vm.sortOption == .price ? .priceReversed :.price
                                  }
  
       
           }
                .frame(width: UIScreen.main.bounds.width / 3,alignment: .trailing)
            
            Button {
                withAnimation(.linear(duration: 2)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
