//
//  View+NavigationBar.swift
//  Noljanolja
//
//  Created by duydinhv on 21/12/2023.
//

import SwiftUI

// MARK: - NavigationBarBackground

struct NavigationBarBackground: ViewModifier {
    let backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .background(
                backgroundColor
                    .ignoresSafeArea()
                    .overlay {
                        ColorAssets.neutralLight.swiftUIColor
                            .ignoresSafeArea(edges: .bottom)
                    }
            )
    }
}

extension View {
    func navigationBarBackground(_ color: Color) -> some View {
        modifier(NavigationBarBackground(backgroundColor: color))
    }
}
