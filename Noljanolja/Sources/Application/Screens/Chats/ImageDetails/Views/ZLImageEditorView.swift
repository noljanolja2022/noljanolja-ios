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
public struct ZLImageEditorView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = ZLEditImageViewController

    @Environment(\.presentationManager) var presentationManager

    let image: Binding<AppKitOrUIKitImage>

    var onCancel: (() -> Void)?

    public func makeUIViewController(context: Context) -> UIViewControllerType {
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])

        return ZLEditImageViewController(
            image: image.wrappedValue,
            editModel: nil
        )
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.base = self
    }

    public class Coordinator: NSObject {
        var base: ZLImageEditorView

        init(base: ZLImageEditorView) {
            self.base = base
        }
    }

    public func makeCoordinator() -> Coordinator {
        .init(base: self)
    }
}

// MARK: - API

public extension ZLImageEditorView {
    init(image: Binding<AppKitOrUIKitImage>,
         onCancel: (() -> Void)? = nil) {
        self.image = image
        self.onCancel = onCancel
    }
}
