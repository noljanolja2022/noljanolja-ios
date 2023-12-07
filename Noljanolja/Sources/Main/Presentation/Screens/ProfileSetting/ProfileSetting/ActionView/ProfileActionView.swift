//
//  ProfileActionView.swift
//  Noljanolja
//
//  Created by duydinhv on 05/12/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - VideoActionView

struct ProfileActionView<ViewModel: ProfileActionViewModel>: View {
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
            .onReceive(viewModel.closeAction) {
                withoutAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 4) {
            ForEach(viewModel.items, id: \.self) { model in
                buildItemView(model)
                    .onTapGesture {
                        viewModel.selectItemAction.send(model)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .frame(height: UIScreen.mainHeight * 0.4, alignment: .top)
        .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildItemView(_ model: ProfileActionItemViewModel) -> some View {
        HStack(spacing: 12) {
            Image(model.imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
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
