//
//  TextFieldStyle.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/03/2023.
//

import Foundation
import SwiftUI
import SwiftUIX

// MARK: - TappableTextFieldStyle

extension CocoaTextField {
    func fullTappable() -> some View {
        introspectTextField { textField in
            textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
    }
}
