//
//  CircleButtonView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 21/06/2026.
//

import SwiftUI

struct CircleButtonView: View {
    let imageName:String
    var body: some View {
        Image(systemName: imageName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50,height: 50)
            .background(Circle()
                .foregroundStyle(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.3), radius: 10)
            .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        
        CircleButtonView(imageName:"heart.fill")
        
        CircleButtonView(imageName: "heart.fill")
            .colorScheme(.dark)
    }
}
