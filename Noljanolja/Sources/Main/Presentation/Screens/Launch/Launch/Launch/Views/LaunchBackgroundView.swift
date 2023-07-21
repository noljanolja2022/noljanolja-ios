//
//  SplashBackgroundView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//

import Foundation
import SwiftUI

struct LaunchBackgroundView: UIViewRepresentable {
    @Binding var isButtonHidden: Bool
    var buttonAction: (() -> Void)?

    func makeUIView(context: Context) -> LaunchBackgroundUIView {
        LaunchBackgroundUIView()
    }

    func updateUIView(_ uiView: LaunchBackgroundUIView, context: Context) {
        uiView.isButtonHidden = isButtonHidden
        uiView.buttonAction = buttonAction
    }
}
