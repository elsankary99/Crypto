//
//  String.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 28/06/2026.
//

import Foundation


extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
