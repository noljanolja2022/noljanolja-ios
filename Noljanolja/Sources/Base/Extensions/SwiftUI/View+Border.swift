//
//  View+Border.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//

import Foundation
import SwiftUI

extension View {
    func overlayBorder(color: Color, cornerRadius: CGFloat = 8, lineWidth: CGFloat = 1) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: lineWidth)
        )
    }
}
