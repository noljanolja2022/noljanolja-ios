//
//  TermOfServiceView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//
//

import SwiftUI
import SwiftUINavigation

// MARK: - TermOfServiceView

struct TermOfServiceView<ViewModel: TermOfServiceViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = TermOfServiceViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildContentView()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .alert(item: $viewModel.state.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildHeaderView()
            VStack(spacing: 0) {
                buildTermItemsView()
                buildActionView()
            }
            .background(ColorAssets.white.swiftUIColor)
            .cornerRadius(40, corners: [.topLeft, .topRight])
        }
        .ignoresSafeArea(edges: [.bottom])
        .background(ColorAssets.primaryYellowMain.swiftUIColor.ignoresSafeArea(edges: [.top]))
    }

    private func buildHeaderView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ImageAssets.logo.swiftUIImage
                .resizable()
                .scaledToFill()
                .frame(width: 66, height: 62)
            Text("Login")
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
            Text("Welcome to Noja Noja. Follow these steps to be our member.")
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
    }

    private func buildTermItemsView() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(TermOfServiceSectionType.allCases) { sectionType in
                    Text(sectionType.title.uppercased())
                        .frame(alignment: .leading)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                        .padding(.top, 32)

                    ForEach(
                        TermOfServiceItemType.allCases
                            .filter {
                                $0.sectionType == sectionType
                            }
                            .sorted { $0.rawValue < $1.rawValue }
                    ) { itemType in
                        TermOfServiceItemView(
                            selected: Binding<Bool>(
                                get: { viewModel.state.termItemCheckeds[itemType] ?? false },
                                set: { viewModel.send(.checkTermItem(itemType: itemType, checked: $0)) }
                            ),
                            title: itemType.title
                        )
                    }
                }
            }
            .padding(16)
        }
    }

    private func buildActionView() -> some View {
        VStack(spacing: 16) {
            TermOfServiceItemView(
                selected: Binding<Bool>(
                    get: { viewModel.state.isAllTermChecked },
                    set: { viewModel.send(.checkAllTermItems(checked: $0)) }
                ),
                title: "I have read and agreed to all terms and conditions",
                titleLineLimit: nil,
                idArrowIconHidden: true
            )

            Button(
                "Agree and Continue",
                action: { viewModel.send(.tapContinueButton) }
            )
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.state.isAllTermChecked))
            .disabled(!viewModel.state.isAllTermChecked)
            .frame(height: 48)

            Text("")
                .frame(
                    height: UIApplication.shared.rootKeyWindow?.safeAreaInsets.bottom ?? 0
                )
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
    }
}

// MARK: - TermOfServiceView_Previews

struct TermOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermOfServiceView()
        }
    }
}
