//
//  TermView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//
//

import SwiftUI
import SwiftUINavigation
import SwiftUIX

// MARK: - TermView

struct TermView<ViewModel: TermViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @State private var selectedTermType: TermItemType?

    var body: some View {
        buildContentView()
            .hideNavigationBar()
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .fullScreenCover(
                unwrapping: $selectedTermType,
                content: { selectedTermType in
                    TermDetailView(
                        viewModel: TermDetailViewModel(),
                        termType: selectedTermType.wrappedValue
                    )
                }
            )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildHeaderView()
            
            VStack(spacing: 0) {
                buildTermItemsView()
                buildActionView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius([.topLeading, .topTrailing], 40)
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

    private func buildHeaderView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ImageAssets.logo.swiftUIImage
                .resizable()
                .scaledToFill()
                .frame(width: 66, height: 62)
            Text(L10n.commonLogin)
                .dynamicFont(.systemFont(ofSize: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
            Text(L10n.authWelcome)
                .dynamicFont(.systemFont(ofSize: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
    }

    private func buildTermItemsView() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(viewModel.termModels.indices, id: \.self) { termModelIndex in
                    let termModel = viewModel.termModels[termModelIndex]
                    Text(termModel.section.title.uppercased())
                        .frame(alignment: .leading)
                        .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .padding(.top, 32)

                    ForEach(termModel.items.indices, id: \.self) { itemIndex in
                        let termItem = termModel.items[itemIndex]
                        TermItemView(
                            selected: Binding<Bool>(
                                get: {
                                    viewModel.termItemCheckeds.contains(termItem)
                                },
                                set: {
                                    if $0 {
                                        viewModel.termItemCheckeds.insert(termItem)
                                    } else {
                                        viewModel.termItemCheckeds.remove(termItem)
                                    }
                                }
                            ),
                            title: termItem.title,
                            idArrowIconHidden: termItem.idArrowIconHidden,
                            action: {
                                if !termItem.idArrowIconHidden {
                                    selectedTermType = termItem
                                }
                            }
                        )
                    }
                }
            }
            .padding(16)
        }
    }

    private func buildActionView() -> some View {
        Button(
            L10n.commonNext.uppercased(),
            action: { viewModel.actionSubject.send() }
        )
        .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isAllTermChecked))
        .disabled(!viewModel.isAllTermChecked)
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .padding(16)
    }
}

// MARK: - TermView_Previews

struct TermView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermView(
                viewModel: TermViewModel()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
