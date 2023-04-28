//
//  SwiftUIView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/04/2023.
//

import PhotoEditorSDK
import SwiftUI

struct ImglyImageEditorView: View {
    // The action to dismiss the view.
    internal var dismissAction: (() -> Void)?

    // The photo being edited.
    let photo: Photo

    var body: some View {
        PhotoEditor(
            photo: photo
        )
        .onDidSave { result in
            // The image has been exported successfully and is passed as an `Data` object in the `result.output.data`.
            // See other examples about how to save the resulting image.
            print("Received image with \(result.output.data.count) bytes")
            dismissAction?()
        }
        .onDidCancel {
            // The user tapped on the cancel button within the editor. Dismissing the editor.
            dismissAction?()
        }
        .onDidFail { error in
            // There was an error generating the photo.
            print("Editor finished with error: \(error.localizedDescription)")
            // Dismissing the editor.
            dismissAction?()
        }
        // In order for the editor to fill out the whole screen it needs
        // to ignore the safe area.
        .ignoresSafeArea()
    }
}
