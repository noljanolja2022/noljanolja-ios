//
//  TermOfServiceView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//
//

import SwiftUI

// MARK: - TermOfServiceView

struct TermOfServiceView<ViewModel: TermOfServiceViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = TermOfServiceViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            content
            navigationLinks
        }
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
                    action: { viewModel.isShowHelpAlert = true },
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
        .alert(isPresented: $viewModel.isShowHelpAlert) {
            Alert(
                title: Text(""),
                message: Text("You may choose to agree to ther terms individually.\nYou may use ther service even if you don't agree to the optional terms and coditions"),
                dismissButton: .cancel()
            )
        }
    }

    private var content: some View {
        VStack {
            allTermItems
            allTermItem
            action
        }
    }

    private var action: some View {
        Button(
            "Agree and Continue",
            action: { viewModel.isShowingAuthView = true }
        )
        .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isAllTermAgreed))
        .disabled(!viewModel.isAllTermAgreed)
        .shadow(
            color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
        )
        .padding(16)
    }

    private var allTermItem: some View {
        TermOfServiceItemView(
            selected: Binding(
                get: { viewModel.isAllTermAgreed },
                set: { value in
                    viewModel.isAllTermAgreed = value
                    viewModel.termItemTypes.keys.forEach {
                        viewModel.termItemTypes[$0] = value
                    }
                }
            ),
            title: "I have read and agreed to all terms and conditions",
            titleLineLimit: nil,
            idArrowIconHidden: true
        )
        .padding(16)
    }

    private var allTermItems: some View {
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
                        let seleted = Binding(
                            get: { viewModel.termItemTypes[itemType] ?? false },
                            set: {
                                viewModel.termItemTypes[itemType] = $0
                                viewModel.isAllTermAgreed = viewModel.termItemTypes
                                    .map { $0.value }
                                    .reduce(true) { $0 && $1 }
                            }
                        )

                        TermOfServiceItemView(
                            selected: seleted,
                            title: itemType.title,
                            action: {}
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

    var navigationLinks: some View {
        NavigationLink(
            isActive: $viewModel.isShowingAuthView,
            destination: { AuthNavigationView() },
            label: { EmptyView() }
        )
    }
}

// MARK: - TermOfServiceView_Previews

struct TermOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        TermOfServiceView()
    }
}
