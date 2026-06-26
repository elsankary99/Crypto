//
//  PortfolioView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 25/06/2026.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var vm: HomeViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCoin:CoinModel? = nil
    @State var quantityText:String = ""
    @State var showCheckmark:Bool = false
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                VStack(alignment: .leading) {
                    SearchBarView(searchText: $vm.searchField)
                    coinLogoList
                    if let currentCoin = selectedCoin {
                    VStack(spacing:20) {
                            HStack {
                                Text("Current Price Of \(currentCoin.symbol.uppercased()):")
                                Spacer()
                                Text(currentCoin.currentPrice.asCurrencyWith6Decimals())
                            }
                            Divider()
                            HStack {
                                Text("Ammount in your portfolio:")
                                Spacer()
                                TextField("Ex:1.4", text: $quantityText)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                                    .frame(width: UIScreen.main.bounds.width/3)
                            }
                        Divider()
                        HStack {
                            Text("Current value:")
                            Spacer()
                            Text(getCurrenttValue.asCurrencyWith2Decimals())
                        }
                        }
                    .padding()
                    .font(.headline)
                    .animation(.none,value: false)
                    }
                  //
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                        print("Dismiss")
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingToolBar
                }
            }
            .onChange(of: vm.searchField) { oldValue, newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
        
    }
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}

extension PortfolioView {
    
    func saveButtonPressed (){
       guard
        let coin = selectedCoin,
        let amount = Double(quantityText)
        else {return}
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin ()
        }
        
        UIApplication.shared.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    func removeSelectedCoin () {
        selectedCoin = nil
        vm.searchField = ""
    }
    
    func updateSelectedCoin(coin: CoinModel){
        selectedCoin = coin
        if let portfolioCon = vm.portofolioCoins.first(where: {$0.id == coin.id}),
           let amount = portfolioCon.currentHoldings {
           quantityText = "\(amount)"
        } else {
          quantityText = ""
        }
    }
    
    var getCurrenttValue: Double {
        if  let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var coinLogoList : some View {
        ScrollView(.horizontal,showsIndicators: false, content: {
            LazyHStack (spacing: 10) {
                ForEach(vm.searchField.isEmpty ? vm.portofolioCoins : vm.allCoins) { coin in
                    portfolioCoinView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                        .onTapGesture {
                            withAnimation {
                                updateSelectedCoin(coin: coin)
                            }
                            
                        }
                }
            }
            .padding(.horizontal)
        })
    }
    
    var trailingToolBar:some View {
        HStack {
            if showCheckmark {
                Image(systemName: "checkmark")
                
            } else {
//                if
//                {
                    Button("Save".uppercased()) {
                    
                        saveButtonPressed()
                    }
                    .disabled(selectedCoin == nil && selectedCoin?.currentHoldings == Double(quantityText))
                    .font(.headline)
                }
//            }
        }
            
    }
}
