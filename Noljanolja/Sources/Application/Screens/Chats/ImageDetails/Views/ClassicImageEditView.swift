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

    @Environment(\.presentationManager) var presentationManager

    let image: Binding<AppKitOrUIKitImage>

    var onCancel: (() -> Void)?

    public func makeUIViewController(context: Context) -> UIViewControllerType {
        var options = ClassicImageEditOptions.default
        options.classes.control.rootControl = ClassicImageEditNoPresetRootControl.self

        return ClassicImageEditViewController(
            imageProvider: ImageProvider(
                image: image.wrappedValue
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

// MARK: - API

public extension ClassicImageEditView {
    init(image: Binding<AppKitOrUIKitImage>,
         onCancel: (() -> Void)? = nil) {
        self.image = image
        self.onCancel = onCancel
    }
}

// MARK: - ClassicImageEditNoPresetRootControl

/// A view that disabled preset and edit selection button.
/// It displays the edit panel directly.

class ClassicImageEditNoPresetRootControl: ClassicImageEditRootControlBase {
    private let containerView = UIView()

    public let editMenuControl: ClassicImageEditEditMenuControlBase

    // MARK: - Initializers

    public required init(viewModel: ClassicImageEditViewModel,
                         editMenuControl: ClassicImageEditEditMenuControlBase,
                         presetListControl: ClassicImageEditPresetListControlBase) {
        self.editMenuControl = editMenuControl

        super.init(
            viewModel: viewModel,
            editMenuControl: editMenuControl,
            presetListControl: presetListControl
        )

        backgroundColor = ClassicImageEditStyle.default.control.backgroundColor

        layout: do {
            addSubview(containerView)

            containerView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: containerView.superview!.topAnchor),
                containerView.leftAnchor.constraint(equalTo: containerView.superview!.leftAnchor),
                containerView.rightAnchor.constraint(equalTo: containerView.superview!.rightAnchor),
                containerView.bottomAnchor.constraint(equalTo: containerView.superview!.bottomAnchor),
                containerView.heightAnchor.constraint(equalToConstant: 50)
            ])

            editMenuControl.frame = containerView.bounds
            editMenuControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(editMenuControl)
        }
    }
}
