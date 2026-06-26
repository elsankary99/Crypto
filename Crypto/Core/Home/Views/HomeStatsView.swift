//
//  HomeStatsView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 25/06/2026.
//

import SwiftUI

struct HomeStatsView: View {

    @Binding var showPortfolio:Bool
 
    @EnvironmentObject var vm : HomeViewModel
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width ,alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(true))
    
}
