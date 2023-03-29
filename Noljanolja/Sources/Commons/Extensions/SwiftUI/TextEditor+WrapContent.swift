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
    func textEditorBackgroundColor(_ color: Color) -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
                .background(color)
        } else {
            return background(color)
        }
    }
}
