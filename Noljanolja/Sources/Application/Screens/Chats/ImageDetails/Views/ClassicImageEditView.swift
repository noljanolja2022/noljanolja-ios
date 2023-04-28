//
//  PixelEditView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/04/2023.
//

import BrightroomEngine
import BrightroomUI
import SwiftUI
import SwiftUIX

// MARK: - ClassicImageEditView

/// A SwiftUI port of `UIImagePickerController`.
public struct ClassicImageEditView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = ClassicImageEditViewController

    private let image: AppKitOrUIKitImage

    init(image: AppKitOrUIKitImage) {
        self.image = image
    }

    public func makeUIViewController(context: Context) -> UIViewControllerType {
        var options = ClassicImageEditOptions.default
        options.classes.control.rootControl = ClassicImageEditNoPresetRootControl.self

        return ClassicImageEditViewController(
            imageProvider: ImageProvider(
                image: image
            ),
            options: options
        )
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.base = self
    }

    public class Coordinator: NSObject {
        var base: ClassicImageEditView

        init(base: ClassicImageEditView) {
            self.base = base
        }
    }

    public func makeCoordinator() -> Coordinator {
        .init(base: self)
    }
}
