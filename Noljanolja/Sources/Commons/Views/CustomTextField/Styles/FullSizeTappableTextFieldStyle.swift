//
//  File.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/02/2023.
//

import Foundation
import SwiftUI

// MARK: - FullSizeTappableTextFieldStyle

struct FullSizeTappableTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        var privateTextField: UITextField?

        return ZStack(alignment: .center) {
            Button(
                action: { privateTextField?.becomeFirstResponder() },
                label: { Text("").frame(maxWidth: .infinity, maxHeight: .infinity) }
            )

            configuration
                .introspectTextField { privateTextField = $0 }
        }
    }
}
