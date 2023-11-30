//
//  ListGiftCategory.swift
//  Noljanolja
//
//  Created by duydinhv on 20/11/2023.
//

import SwiftUI

struct ListGiftCategoryView<ViewModel: ListGiftCategoryViewModel>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    let title = viewModel.category != nil ? viewModel.category?.name ?? "" : viewModel.brand?.name ?? ""
                    Text(title)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        if viewModel.category != nil {
            ShopGiftView(viewModel: ShopGiftViewModel(categoryId: viewModel.category?.id))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ShopGiftView(viewModel: ShopGiftViewModel(brandId: viewModel.brand?.id))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// struct ListGiftCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListGiftCategoryView()
//    }
// }
