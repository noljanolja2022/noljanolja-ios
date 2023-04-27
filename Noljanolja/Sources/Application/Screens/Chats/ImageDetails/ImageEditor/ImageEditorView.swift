//
//  ImageEditorView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/04/2023.
//
//

import SwiftUI

// MARK: - ImageEditorView

struct ImageEditorView<ViewModel: ImageEditorViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZLImageEditorView(
            image: .constant(viewModel.image),
            onCancel: nil
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Image(systemName: "xmark")
                    }
                )
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
    }
}

// MARK: - ImageEditorView_Previews

struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditorView(
            viewModel: ImageEditorViewModel(
                image: UIImage()
            )
        )
    }
}
