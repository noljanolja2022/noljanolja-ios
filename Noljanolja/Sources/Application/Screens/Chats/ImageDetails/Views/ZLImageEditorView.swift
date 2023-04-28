//
//  ZLImageEditorView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/04/2023.
//

import SwiftUI
import SwiftUIX
import ZLImageEditor

// MARK: - ZLImageEditorView

/// A SwiftUI port of `UIImagePickerController`.
struct ZLImageEditorView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ZLEditImageViewController

    private let image: AppKitOrUIKitImage

    init(image: AppKitOrUIKitImage) {
        self.image = image
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])

        return ZLEditImageViewController(
            image: image,
            editModel: nil
        )
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.base = self
    }

    class Coordinator: NSObject {
        var base: ZLImageEditorView

        init(base: ZLImageEditorView) {
            self.base = base
        }
    }

    func makeCoordinator() -> Coordinator {
        .init(base: self)
    }
}
