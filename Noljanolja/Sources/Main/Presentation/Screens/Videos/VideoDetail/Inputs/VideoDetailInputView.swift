//
//  VideoDetailInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/04/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUIX

// MARK: - VideoDetailInputView

struct VideoDetailInputView<ViewModel: VideoDetailInputViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State
    
    @StateObject private var keyboard = Keyboard.main
    @State private var text = ""

    private let inputItemSize: CGFloat = 36

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
    }

    private func buildContentView() -> some View {
        HStack(alignment: .bottom, spacing: 12) {
            buildAvatarView()
            buildTextInputView()
            buildSendView()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func buildAvatarView() -> some View {
        WebImage(
            url: URL(string: viewModel.user?.avatar),
            context: [
                .imageTransformer: SDImageResizingTransformer(
                    size: CGSize(width: 64 * 3, height: 64 * 3),
                    scaleMode: .aspectFill
                )
            ]
        )
        .resizable()
        .indicator(.activity)
        .scaledToFill()
        .padding(6)
        .frame(width: inputItemSize, height: inputItemSize)
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
        .cornerRadius(32)
    }

    private func buildTextInputView() -> some View {
        ZStack(alignment: .center) {
            if text.isEmpty {
                Text("Aa")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                    .padding(.horizontal, 6)
            }
            TextEditor(text: $text)
                .textEditorBackgroundColor(.clear)
                .padding(.vertical, 1)
                .frame(minHeight: inputItemSize)
                .frame(maxHeight: 64)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
        .dynamicFont(.systemFont(ofSize: 14))
        .padding(.horizontal, 8)
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
        .cornerRadius(inputItemSize / 2)
    }

    private func buildSendView() -> some View {
        Button(
            action: {
                viewModel.sendCommentAction.send(text)
                text = ""
            },
            label: {
                ImageAssets.icSend.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: inputItemSize, height: inputItemSize)
            }
        )
        .foregroundColor(
            text.isEmpty
                ? ColorAssets.neutralDeepGrey.swiftUIColor
                : ColorAssets.primaryGreen200.swiftUIColor
        )
    }
}

// MARK: - VideoDetailInputView_Previews

struct VideoDetailInputView_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetailInputView(
            viewModel: VideoDetailInputViewModel(
                videoId: ""
            )
        )
    }
}
