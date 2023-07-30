//
//  MyRankingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/05/2023.
//
//

import SwiftUI

// MARK: - MyRankingView

struct MyRankingView<ViewModel: MyRankingViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.myRankingTitle)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { false },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        if let model = viewModel.model {
            ScrollView {
                LazyVStack(spacing: 12) {
                    buildCurrentTierView(
                        currentModel: model.currentTierModelType,
                        nextModel: model.nextTierModelType
                    )
                    buildTiersView(model.tierModelTypes)
                }
            }
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
        }
    }

    @ViewBuilder
    private func buildCurrentTierView(currentModel: LoyaltyTierModelType?,
                                      nextModel: LoyaltyTierModelType?) -> some View {
        if let currentModel {
            VStack(spacing: 8) {
                ImageAssets.icRank.swiftUIImage
                    .resizable()
                    .frame(width: 45, height: 34)
                    .foregroundColor(Color(currentModel.iconColor))

                Text(currentModel.text)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                Text("If 2 additional people are General membership\nthe group will be promoted")
                    .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .background(ColorAssets.secondaryYellow100.swiftUIColor)
                    .cornerRadius(8)

                buildNextTierView(nextModel)
            }
            .padding(16)
            .background(ColorAssets.neutralLight.swiftUIColor)
        }
    }

    @ViewBuilder
    private func buildNextTierView(_ model: LoyaltyTierModelType?) -> some View {
        if let model {
            VStack(spacing: 8) {
                Text("Expected rating for next month")
                    .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)

                ImageAssets.icRank.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 18)
                    .foregroundColor(Color(model.iconColor))

                Text(model.text)
                    .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                    .frame(height: 28)
                    .padding(.horizontal, 12)
                    .foregroundColor(Color(model.textColor))
                    .background(Color(model.backgroundColor))
                    .cornerRadius(14)
            }
        }
    }

    private func buildTiersView(_ models: [LoyaltyTierModelType]) -> some View {
        LazyVStack(spacing: 12) {
            ForEach(models.indices, id: \.self) {
                buildTierItemView(models[$0])
            }
        }
        .padding(.horizontal, 16)
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.15),
            radius: 2,
            x: 0,
            y: 2
        )
    }

    private func buildTierItemView(_ model: LoyaltyTierModelType) -> some View {
        HStack(spacing: 24) {
            ImageAssets.icRank.swiftUIImage
                .resizable()
                .frame(width: 24, height: 18)
                .foregroundColor(Color(model.iconColor))
                .frame(width: 32, height: 32)
                .background(Color(model.backgroundColor))
                .cornerRadius(4)

            Text(model.text)
                .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 48)
        .padding(.vertical, 24)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(8)
    }
}

extension MyRankingView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildErrorView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }
}

// MARK: - MyRankingView_Previews

struct MyRankingView_Previews: PreviewProvider {
    static var previews: some View {
        MyRankingView(viewModel: MyRankingViewModel())
    }
}
