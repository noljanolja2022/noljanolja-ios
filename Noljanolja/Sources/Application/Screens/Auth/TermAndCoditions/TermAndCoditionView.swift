//
//  TermAndConditionView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//
//

import SwiftUI

// MARK: - TermAndConditionView

struct TermAndConditionView: View {
    @StateObject private var viewModel: TermAndConditionViewModel

    @State private var isShowingSignUpView = false

    init(viewModel: TermAndConditionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            content
            NavigationLink(
                destination: SignUpView(),
                isActive: $isShowingSignUpView,
                label: { EmptyView() }
            )
        }
        .navigationBarHidden(true)
    }

    private var content: some View {
        VStack(spacing: 12) {
            terms
            PrimaryButton(
                title: L10n.Common.next,
                action: {
                    viewModel.signUpStep = .second
                    isShowingSignUpView = true
                },
                isEnabled: $viewModel.allTermAgreed
            )
            .padding(.horizontal, 16)
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
                        minTitleWidth: array.map { $0.key }.maxTitleWidth(with: FontFamily.NotoSans.medium.font(size: 14))
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

// MARK: - TermAndConditionView_Previews

struct TermAndConditionView_Previews: PreviewProvider {
    @State private static var step: SignUpStep = .first

    static var previews: some View {
        TermAndConditionView(viewModel: TermAndConditionViewModel(signUpStep: $step))
    }
}
