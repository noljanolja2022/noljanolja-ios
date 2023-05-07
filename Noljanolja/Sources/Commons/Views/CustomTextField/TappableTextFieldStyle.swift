//
//  File.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/02/2023.
//

import Foundation
import SwiftUI

// MARK: - TappableTextFieldStyle

struct TappableTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        var privateTextField: UITextField?

        return ZStack(alignment: .center) {
            Button(
                action: { privateTextField?.becomeFirstResponder() },
                label: { Spacer().frame(maxWidth: .infinity, maxHeight: .infinity) }
            )

            configuration
                .introspectTextField { privateTextField = $0 }
        }
    }
}
