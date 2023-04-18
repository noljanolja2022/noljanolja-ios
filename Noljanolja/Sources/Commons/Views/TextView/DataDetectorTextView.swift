//
//  HyperTextView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/04/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - DataDetectorTextView

struct DataDetectorTextView: UIViewRepresentable {
    let text: Binding<String>
    let dataAction: ((String) -> Void)?

    var font: Font = .system(size: 14)
    var dataDetectorTypes: UIDataDetectorTypes = .all
    var isEditable = false
    var isScrollEnabled = false
    var foregroundColor = Color.black

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear

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

    func updateUIView(_ uiView: UITextView, context: Context) {
        context.coordinator.base = self

        updateUIView(uiView)
    }

    func makeCoordinator() -> Coordinator {
        .init(base: self)
    }

    private func updateUIView(_ uiView: UITextView) {
        uiView.text = text.wrappedValue

        uiView.linkTextAttributes = [
            .foregroundColor: foregroundColor.toUIColor() ?? .blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        uiView.dataDetectorTypes = dataDetectorTypes
        uiView.font = try? font.toAppKitOrUIKitFont()
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
    func font(_ font: Font) -> Self {
        then { $0.font = font }
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

// MARK: - DataDetectorTextView_Previews

struct DataDetectorTextView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                DataDetectorTextView(
                    text: .constant("Hello, https://stackoverflow.com/questions/60277944/swiftui-how-can-i-get-multiline-text-to-wrap-in-a-uitextview-without-scrolling"),
                    dataAction: nil
                )
                .font(.system(size: 14, weight: .regular))
                .dataDetectorTypes(.link)
                .isEditable(false)
                .isScrollEnabled(false)
                .background(.green)

                Spacer()
                    .frame(minWidth: 30)
            }

            Spacer()
                .frame(maxHeight: .infinity)
        }
    }
}
