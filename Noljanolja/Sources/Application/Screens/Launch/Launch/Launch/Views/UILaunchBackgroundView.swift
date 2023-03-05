//
//  SplashBackgroundView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//

import Foundation
import UIKit

@IBDesignable final class UILaunchBackgroundView: UIView, NibOwnerLoadable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        loadNibContent()
    }
}
