//
//  TermsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/02/2023.
//
//

import SwiftUI

// MARK: - TermsView

struct TermsView<ViewModel: TermsViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel = TermsViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            content
            NavigationLink(
                destination: SignUpView(
                    viewModel: SignUpViewModel(delegate: viewModel)
                ),
                isActive: $viewModel.isShowingSignUpView,
                label: { EmptyView() }
            )
        }
        .onAppear { viewModel.updateSignUpStepTrigger.send(.first) }
    }

    private var content: some View {
        VStack {
            terms
            Button(
                L10n.Common.next,
                action: { viewModel.isShowingSignUpView = true }
            )
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.allTermAgreed))
            .disabled(!viewModel.allTermAgreed)
            .padding(16)
        }
    }

    private var terms: some View {
        ScrollView {
            VStack(spacing: 12) {
                TermItemView(
                    selected: Binding(
                        get: { viewModel.allTermAgreed },
                        set: { value in
                            viewModel.allTermAgreed = value
                            viewModel.termItemTypes.keys.forEach {
                                viewModel.termItemTypes[$0] = value
                            }
                        }
                    ),
                    title: "Full agreement",
                    idArrowIconHidden: true
                )

                Divider()
                    .background(ColorAssets.gray.swiftUIColor)
                    .frame(height: 1)

                ForEach(0..<viewModel.termItemTypes.count, id: \.self) { index in
                    let array = viewModel.termItemTypes
                        .map { $0 }
                        .sorted { $0.key.rawValue < $1.key.rawValue }
                    let itemType = array[index].key
                    let seleted = Binding(
                        get: { array[index].value },
                        set: {
                            viewModel.termItemTypes[itemType] = $0
                            viewModel.allTermAgreed = viewModel.termItemTypes
                                .map { $0.value }
                                .reduce(true) { $0 && $1 }
                        }
                    )

                    TermItemView(
                        selected: seleted,
                        title: itemType.title,
                        description: itemType.description,
                        minTitleWidth: array.map { $0.key }.maxTitleWidth(with: FontFamily.NotoSans.medium.font(size: 14)),
                        action: { viewModel.selectedtermItemType = itemType }
                    )

                    if itemType.isSeparatoRequired {
                        Divider()
                            .background(ColorAssets.gray.swiftUIColor)
                            .frame(height: 1)
                    }
                }
            }
            .padding(16)
        }
        .introspectScrollView { scrollView in
            scrollView.alwaysBounceVertical = false
        }
    }
}

// MARK: - TermsView_Previews

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}
