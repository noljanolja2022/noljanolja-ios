//
//  HyperTextView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/04/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - DataDetectorUITextView

final class DataDetectorUITextView: UITextView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let pos = closestPosition(to: point) else { return false }
        guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: .layout(.left)) else { return false }
        let startIndex = offset(from: beginningOfDocument, to: range.start)
        let result = attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
        return result
    }
}

// MARK: - DataDetectorTextView

struct DataDetectorTextView: UIViewRepresentable {
    @Environment(\.sizeCategory) private var contentSizeCategory

    let text: Binding<String>
    let dataAction: ((String) -> Void)?

    var font: UIFont = .systemFont(ofSize: 14)
    var isDynamicFontEnabled = false
    var dataDetectorTypes: UIDataDetectorTypes = .all
    var isEditable = false
    var isScrollEnabled = false
    var foregroundColor = Color.black

    func makeUIView(context: Context) -> DataDetectorUITextView {
        let textView = DataDetectorUITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear

        textView.clipsToBounds = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentHuggingPriority(.required, for: .horizontal)
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        textView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.didTapView(_:))
            )
        )

        updateUIView(textView)

        return textView
    }

    func updateUIView(_ uiView: DataDetectorUITextView, context: Context) {
        context.coordinator.base = self

        updateUIView(uiView)
    }

    func makeCoordinator() -> Coordinator {
        .init(base: self)
    }

    private func updateUIView(_ uiView: DataDetectorUITextView) {
        uiView.text = text.wrappedValue

        uiView.linkTextAttributes = [
            .foregroundColor: foregroundColor.toUIColor() ?? .blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        uiView.dataDetectorTypes = dataDetectorTypes
        if isDynamicFontEnabled {
            let dynamicUIFont = font.dynamicFont(
                contentSizeCategory: contentSizeCategory,
                minScale: DynamicFont.minScale,
                maxScale: DynamicFont.maxScale
            )
            uiView.font = dynamicUIFont
        } else {
            uiView.font = font
        }
        uiView.isEditable = isEditable
        uiView.isScrollEnabled = isScrollEnabled
        uiView.textColor = foregroundColor.toUIColor()
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var base: DataDetectorTextView

        init(base: DataDetectorTextView) {
            self.base = base
        }

        func textViewDidChange(_ textView: UITextView) {
            base.text.wrappedValue = textView.text
        }

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            false
        }

        @objc func didTapView(_ recognizer: UITapGestureRecognizer) {
            guard let view = recognizer.view, let textView = view as? UITextView else { return }
            let tapLocation = recognizer.location(in: textView)
            guard let textPosition = textView.closestPosition(to: tapLocation),
                  let url = textView.textStyling(at: textPosition, in: .forward)?[NSAttributedString.Key.link],
                  let urlString = (url as? String) ?? (url as? URL)?.absoluteString else {
                return
            }
            base.dataAction?(urlString)
        }
    }
}

extension DataDetectorTextView {
    func dynamicFont(_ font: UIFont, isDynamicFontEnabled: Bool = false) -> Self {
        then {
            $0.font = font
            $0.isDynamicFontEnabled = isDynamicFontEnabled
        }
    }

    func dataDetectorTypes(_ dataDetectorTypes: UIDataDetectorTypes) -> Self {
        then { $0.dataDetectorTypes = dataDetectorTypes }
    }

    func isEditable(_ isEditable: Bool) -> Self {
        then { $0.isEditable = isEditable }
    }

    func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
        then { $0.isScrollEnabled = isScrollEnabled }
    }

    func foregroundColor(_ foregroundColor: Color) -> Self {
        then { $0.foregroundColor = foregroundColor }
    }
}

// MARK: - DataDetectorTextViewDynamicFont

struct DataDetectorTextViewDynamicFont: View {
    @Environment(\.sizeCategory) private var contentSizeCategory

    let content: () -> DataDetectorTextView
    let font: UIFont

    var body: some View {
        let dynamicUIFont = font.dynamicFont(
            contentSizeCategory: contentSizeCategory,
            minScale: DynamicFont.minScale,
            maxScale: DynamicFont.maxScale
        )
        let dynamicFont = Font(dynamicUIFont)
        return content().font(dynamicFont)
    }
}
