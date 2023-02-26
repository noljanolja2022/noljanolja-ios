//
//  TermDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/02/2023.
//
//

import SwiftUI

// MARK: - TermDetailView

struct TermDetailView<ViewModel: TermDetailViewModelType>: View {
    // MARK: View Model

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            content
            action
                .padding(16)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.termItemType.title)
                    Text(viewModel.termItemType.description)
                }
                .font(FontFamily.NotoSans.bold.swiftUIFont(size: 16))
            }
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
    }

    private var content: some View {
        ScrollView {
            Text(viewModel.termItemType.content)
                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 11))
                .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                .padding(16)
        }
    }

    private var action: some View {
        Button(
            L10n.Common.previous,
            action: { presentationMode.wrappedValue.dismiss() }
        )
        .buttonStyle(ThridyButtonStyle())
        .shadow(
            color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
        )
    }
}

// MARK: - TermDetailView_Previews

struct TermDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TermDetailView(viewModel: TermDetailViewModel(termItemType: .termOfService))
    }
}
