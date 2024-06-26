//
//  SplashBackgroundView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//

import Foundation
import UIKit

@IBDesignable final class LaunchBackgroundUIView: UIView, NibOwnerLoadable {
    @IBOutlet private var mesageLabel: UILabel!
    @IBOutlet private var button: UIButton!
    var buttonAction: (() -> Void)?

    @IBInspectable var isButtonHidden: Bool {
        get { button.isHidden }
        set { button.isHidden = newValue }
    }

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

        mesageLabel.text = L10n.authWelcome
        button.setTitle(L10n.splashExplore, for: .normal)
    }

    @IBAction func didTapButton(_: Any) {
        buttonAction?()
    }
}
