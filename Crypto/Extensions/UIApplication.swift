//
//  UIApplication.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 24/06/2026.
//

import Foundation
import SwiftUI


extension UIApplication {
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
