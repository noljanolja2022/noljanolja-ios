//
//  VideoActionView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/07/2023.
//
//

import SwiftUI

// MARK: - VideoActionView

struct VideoActionView<ViewModel: VideoActionViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 4) {
            ForEach(viewModel.items.indices, id: \.self) { index in
                let model = viewModel.items[index]
                buildItemView(model)
                    .onTapGesture {
                        viewModel.selectItemAction.send(model)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private func buildItemView(_ model: VideoActionItemViewModel) -> some View {
        HStack(spacing: 12) {
            Image(model.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(2)

            Text(model.title)
                .dynamicFont(.systemFont(ofSize: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }
}
