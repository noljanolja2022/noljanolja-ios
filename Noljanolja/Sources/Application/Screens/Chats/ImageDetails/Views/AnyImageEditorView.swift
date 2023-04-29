//
//  AnyImageEditorView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/04/2023.
//

import AnyImageKit
import Foundation
import SwiftUI
import SwiftUIX

// MARK: - AnyImageEditorView

/// A SwiftUI port of `UIImagePickerController`.
struct AnyImageEditorView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ImageEditorController

    private let image: AppKitOrUIKitImage
    fileprivate let finishEditingAction: ((UIImage?) -> Void)?

    init(image: AppKitOrUIKitImage,
         finishEditingAction: ((UIImage?) -> Void)? = nil) {
        self.image = image
        self.finishEditingAction = finishEditingAction
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        var options = EditorPhotoOptionsInfo()
        options.theme[icon: .returnBackButton] = ImageAssets.icClose.image
            .withTintColor(ColorAssets.neutralLight.color, renderingMode: .alwaysOriginal)
        options.theme.configurationButton(for: .done) { button in
            button.layerCornerRadius = 8
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.setTitleColor(ColorAssets.neutralLight.color, for: .normal)
            button.setTitleColor(ColorAssets.neutralLightGrey.color, for: .highlighted)
            button.backgroundColor = ColorAssets.primaryMain.color
        }
        options.toolOptions = [.crop, .text, .brush, .mosaic]
        return ImageEditorController(
            photo: image,
            options: options,
            delegate: context.coordinator
        )
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.base = self
    }

    class Coordinator: NSObject, ImageEditorControllerDelegate {
        var base: AnyImageEditorView

        init(base: AnyImageEditorView) {
            self.base = base
        }

        func imageEditor(_ editor: ImageEditorController, didFinishEditing result: EditorResult) {
            base.finishEditingAction?(result.image)
        }
    }

    func makeCoordinator() -> Coordinator {
        .init(base: self)
    }
}

private extension EditorResult {
    var image: UIImage? {
        switch type {
        case .photo, .photoGIF, .photoLive:
            if let data = try? Data(contentsOf: mediaURL) {
                return UIImage(data: data)
            } else {
                return nil
            }
        case .video:
            return nil
        }
    }
}
