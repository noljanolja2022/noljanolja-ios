//
//  ImagePickerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/03/2023.
//

import SwiftUI
import UIKit

// MARK: - ImagePickerView.Coordinator

extension ImagePickerView {
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image: UIImage? = {
                if let image = info[.editedImage] as? UIImage {
                    return image
                } else if let image = info[.originalImage] as? UIImage {
                    return image
                } else {
                    return nil
                }
            }()
            parent.selection = image
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - ImagePickerView

struct ImagePickerView: UIViewControllerRepresentable {
    typealias SourceType = UIImagePickerController.SourceType

    // MARK: Dependencies

    @Binding var selection: UIImage?
    var sourceType: SourceType = .photoLibrary
    var allowsEditing = false

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.sourceType = sourceType
        viewController.allowsEditing = allowsEditing
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ viewController: UIImagePickerController, context: Context) {
        viewController.delegate = context.coordinator
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: - ImagePickerView.SourceType + Identifiable

extension ImagePickerView.SourceType: Identifiable {
    public var id: Int {
        rawValue
    }
}

// MARK: - ImagePickerView_Previews

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(selection: .constant(nil))
    }
}
