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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Verification")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                        .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: { viewModel.send(.openHelpAlert) },
                        label: {
                            ImageAssets.icQuestionmarkCircle.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(12)
                        }
                    )
                    .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                }
            }
            .alert(item: $viewModel.state.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        VStack {
            buildTermItemsView()
            buildAllTermView()
            buildActionView()
        }
    }

    private func buildTermItemsView() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(TermOfServiceSectionType.allCases) { sectionType in
                    Text(sectionType.title)
                        .frame(height: 32, alignment: .leading)
                        .font(FontFamily.NotoSans.medium.swiftUIFont(size: 12))
                        .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)

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

                        Divider()
                            .background(ColorAssets.gray.swiftUIColor)
                            .frame(height: 1)
                    }
                }
            }
            .padding(16)
        }
    }

    private func buildAllTermView() -> some View {
        TermOfServiceItemView(
            selected: Binding<Bool>(
                get: { viewModel.state.isAllTermChecked },
                set: { viewModel.send(.checkAllTermItems(checked: $0)) }
            ),
            title: "I have read and agreed to all terms and conditions",
            titleLineLimit: nil,
            idArrowIconHidden: true
        )
        .padding(16)
    }

    private func buildActionView() -> some View {
        Button(
            "Agree and Continue",
            action: { viewModel.send(.tapContinueButton) }
        )
        .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.state.isAllTermChecked))
        .disabled(!viewModel.state.isAllTermChecked)
        .shadow(
            color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
        )
        .padding(16)
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
