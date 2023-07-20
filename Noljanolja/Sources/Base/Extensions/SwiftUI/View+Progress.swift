//
//  View+Progress.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import Combine
import SwiftUI
import SwiftUIX

extension View {
    func progressHUB(isActive: Binding<Bool>) -> some View {
        modifier(ProgressHUBViewModifier(isActive: isActive))
    }
}

// MARK: - ProgressHUBViewModifier

struct ProgressHUBViewModifier: ViewModifier {
    @Binding var isActive: Bool

    func body(content: Content) -> some View {
        content.overlay {
            if isActive {
                let _ = Keyboard.main.dismiss()
                ProgressHUDView()
            }
        }
    }
}
