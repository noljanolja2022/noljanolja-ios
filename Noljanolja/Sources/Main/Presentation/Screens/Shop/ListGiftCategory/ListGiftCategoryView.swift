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
                    Text(viewModel.category.name)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        ShopGiftView(viewModel: ShopGiftViewModel(categoryId: viewModel.category.id))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// struct ListGiftCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListGiftCategoryView()
//    }
// }
