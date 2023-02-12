//
//  CustomTextField.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/02/2023.
//

import SwiftUI
import UIKit

// MARK: - CustomTextField

struct CustomTextField: UIViewRepresentable {
    var placeholder = ""
    @Binding var text: String
    var font: UIFont = .systemFont(ofSize: 16)
    var forcegroundColor: UIColor = .black
    var isSecureTextEntry = false
    var contentInset: UIEdgeInsets = .zero

    func makeUIView(context: Context) -> CustomUITextField {
        let textField = CustomUITextField()
        textField.addTarget(
            context.coordinator,
            action: #selector(context.coordinator.textFieldDidChange),
            for: .editingChanged
        )
        return textField
    }

    func updateUIView(_ uiView: CustomUITextField, context: Context) {
        uiView.placeholder = placeholder
        uiView.text = text
        uiView.font = font
        uiView.isSecureTextEntry = isSecureTextEntry
        uiView.contentInset = contentInset
    }

    func makeCoordinator() -> CustomTextFieldCoordinator {
        CustomTextFieldCoordinator(self)
    }
}

// MARK: - CustomTextFieldCoordinator

final class CustomTextFieldCoordinator {
    private let view: CustomTextField

    init(_ view: CustomTextField) {
        self.view = view
    }

    @objc
    func textFieldDidChange(textField: UITextField) {
        view.text = textField.text ?? ""
    }
}

// MARK: - CustomUITextField

final class CustomUITextField: UITextField {
    var contentInset = UIEdgeInsets.zero {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init() {
        self.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInset)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }
}
