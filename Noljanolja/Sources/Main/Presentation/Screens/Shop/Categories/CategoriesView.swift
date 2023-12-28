//
//  CategoriesView.swift
//  Noljanolja
//
//  Created by duydinhv on 20/11/2023.
//

import SwiftUI

// MARK: - CategoriesView

struct CategoriesView<ViewModel: CategoriesViewModel>: View {
    @StateObject var viewModel: CategoriesViewModel
    @EnvironmentObject var themeManager: AppThemeManager

    var onTap: ((GiftCategory) -> Void)?

    var body: some View {
        buildContentStatefullView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    @ViewBuilder
    private func buildContentStatefullView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.models.isEmpty },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(enumerating: viewModel.models, id: \.id) { index, item in
                    Text(item.name)
                        .dynamicFont(.systemFont(ofSize: 14))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 13)
                        .background(viewModel.selectedIndex == index
                            ? themeManager.theme.primary200
                            : ColorAssets.neutralLightGrey.swiftUIColor
                        )
                        .cornerRadius(5)
                        .onPress {
                            viewModel.selectedIndex = index
                            if viewModel.models[index].name != "All" {
                                onTap?(item)
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

extension CategoriesView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        EmptyView()
    }

    private func buildErrorView() -> some View {
        EmptyView()
    }
}

// MARK: - CategoriesView_Previews

// struct CategoriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoriesView()
//    }
// }
