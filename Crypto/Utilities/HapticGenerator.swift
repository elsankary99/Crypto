//
//  HapticGenerator.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 26/06/2026.
//

import Foundation
import SwiftUI

class HapticGenerator {
    static private let generator = UINotificationFeedbackGenerator(view: .appearance())
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
