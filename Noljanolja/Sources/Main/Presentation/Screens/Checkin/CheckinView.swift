//
//  CheckinView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//
//

import SwiftUI

// MARK: - CheckinView

struct CheckinView<ViewModel: CheckinViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildNavigationLinks()
            buildMainView()
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(L10n.menuCheckoutAndPlay)
                    .lineLimit(1)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
        .isProgressHUBVisible($viewModel.isProgressHUDShowing)
        .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildMainView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.model?.isEmpty ?? true },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 8) {
            ScrollView {
                VStack(spacing: 0) {
                    buildSummaryView()
                    buildMiddleButton()
                    buildDetailView()
                }
            }

            buildActionButton()
        }
    }

    @ViewBuilder
    private func buildSummaryView() -> some View {
        if let model = viewModel.model {
            VStack(spacing: 20) {
                Text(model.currentDate.string(withFormat: "MM/dd"))
                    .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(ColorAssets.neutralRawLight.swiftUIColor)

                CheckinProgressSumaryView(
                    completedCount: model.checkinProgresses.filter { $0.isCompleted }.count,
                    count: model.checkinProgresses.count,
                    forcegroundColor: ColorAssets.neutralRawLight.swiftUIColor,
                    secondaryForcegroundColor: ColorAssets.neutralRawDeepGrey.swiftUIColor
                )
                .frame(width: UIScreen.main.bounds.width / 2)

                CheckinOverviewView()
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .background(ColorAssets.neutralRawLight.swiftUIColor)
                    .cornerRadius(8)
                    .padding(16)
            }
            .padding(.vertical, 16)
            .background(ColorAssets.neutralRawDarkGrey.swiftUIColor)
        }
    }

    private func buildMiddleButton() -> some View {
        Button(
            action: {
                viewModel.navigationType = .referral
            },
            label: {
                HStack(spacing: 32) {
                    Text(L10n.referalGoToDetail)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))

                    ImageAssets.icArrowRight.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
            }
        )
        .buttonStyle(PrimaryButtonStyle())
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .background(ColorAssets.neutralRawDarkGrey.swiftUIColor)
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .background(
            ColorAssets.neutralRawDarkGrey.swiftUIColor
                .padding(.bottom, 24)
        )
    }

    @ViewBuilder
    private func buildDetailView() -> some View {
        if let model = viewModel.model {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    var shortWeekdaySymbols: [String] = DateFormatter().shortWeekdaySymbols
                    let firstWeekday = 2
                    let weekdays = shortWeekdaySymbols[firstWeekday - 1..<shortWeekdaySymbols.count] + shortWeekdaySymbols[0..<firstWeekday - 1]
                    ForEach(weekdays.indices, id: \.self) { index in
                        Text(weekdays[index])
                            .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem.flexible(spacing: 8), count: 7), spacing: 8) {
                    ForEach(model.itemViewModels.indices, id: \.self) { index in
                        let model = model.itemViewModels[index]
                        CheckinItemView(
                            model: model
                        )
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .padding(16)
        } else {
            Spacer()
                .frame(maxHeight: .infinity)
        }
    }

    private func buildActionButton() -> some View {
        Button(
            L10n.walletCheckin.uppercased(),
            action: {
                viewModel.action.send()
            }
        )
        .disabled(!(viewModel.model?.isCheckinEnabled ?? false))
        .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.model?.isCheckinEnabled ?? false))
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .padding(.horizontal, 16)
    }
}

extension CheckinView {
    private func buildNavigationLinks() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: {
                buildNavigationLinkDestinationView($0)
            },
            label: {
                EmptyView()
            }
        )
    }

    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<CheckinNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .referral:
            ReferralView(
                viewModel: ReferralViewModel()
            )
        }
    }
}

extension CheckinView {
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

// MARK: - CheckinView_Previews

struct CheckinView_Previews: PreviewProvider {
    static var previews: some View {
        CheckinView(viewModel: CheckinViewModel())
    }
}
