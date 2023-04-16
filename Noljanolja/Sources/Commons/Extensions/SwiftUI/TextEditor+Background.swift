//
//  TextEditor+WrapContent.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/03/2023.
//

import Foundation
import SwiftUI
import SwiftUIX

extension View {
    @ViewBuilder
    func textEditorBackgroundColor(_ color: Color) -> some View {
        if #available(iOS 16.0, *) {
            scrollContentBackground(.hidden)
                .background(color)
        } else {
            let _ = UITextView.appearance().backgroundColor = .clear
            background(color)
        }
    }
}
