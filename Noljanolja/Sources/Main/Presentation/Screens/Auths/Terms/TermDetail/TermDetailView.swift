//
//  TermDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/04/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - TermDetailView

struct TermDetailView<ViewModel: TermDetailViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    var termType: TermItemType

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        VStack(spacing: 8) {
            buildHeaderView()
            buildContentView()
        }
        .background(
            ColorAssets.neutralLight.swiftUIColor
                .ignoresSafeArea()
                .overlay {
                    ColorAssets.primaryGreen200.swiftUIColor
                        .ignoresSafeArea(edges: .top)
                }
        )
    }

    @ViewBuilder
    private func buildHeaderView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    ImageAssets.icClose.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .frame(width: 24, height: 24)
                }
            )

            Text(L10n.tosTitle)
                .dynamicFont(.systemFont(ofSize: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(L10n.tosWelcome)
                .dynamicFont(.systemFont(ofSize: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            Text(termType.title)
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .frame(height: 44)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 32)
            ScrollView {
                Text(termType.description)
                    .dynamicFont(.systemFont(ofSize: 12))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .padding(.horizontal, 16)
        }
        .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
        .cornerRadius([.topLeading, .topTrailing], 40)
    }
}

// MARK: - TermDetailView_Previews

struct TermDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TermDetailView(
            viewModel: TermDetailViewModel(),
            termType: .collectProfileInformation
        )
    }
}
