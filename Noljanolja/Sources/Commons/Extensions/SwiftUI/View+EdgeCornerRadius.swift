//
//  View+EdgeCornerRadius.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/02/2023.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - RoundedCorner

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
