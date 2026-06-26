//
//  XMarkView.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 25/06/2026.
//

import SwiftUI

struct XMarkView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }

    }
}

#Preview {
    XMarkView()
}
