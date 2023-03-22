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

    func makeUIView(context: Context) -> UILaunchBackgroundView {
        UILaunchBackgroundView()
    }

    func updateUIView(_ uiView: UILaunchBackgroundView, context: Context) {
        uiView.isButtonHidden = isButtonHidden
        uiView.buttonAction = buttonAction
    }
}
