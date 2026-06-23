//
//  CircleButtonAnimation.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 21/06/2026.
//

import SwiftUI

struct CircleButtonAnimation: View {
    @Binding var animate:Bool
    var body: some View {
        
        Circle()
            .stroke(lineWidth: 3)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0 : 1)
            .tint(Color.theme.accent)
            .animation(animate ? Animation.easeInOut(duration: 1.0) : .none, value: animate)
 
    }
}

#Preview {
    CircleButtonAnimation(animate: .constant(false))
}
