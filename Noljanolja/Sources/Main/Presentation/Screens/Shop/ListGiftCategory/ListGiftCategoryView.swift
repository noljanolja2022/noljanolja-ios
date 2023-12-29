//
//  ListGiftCategory.swift
//  Noljanolja
//
//  Created by duydinhv on 20/11/2023.
//

import SwiftUI

struct ListGiftCategoryView<ViewModel: ListGiftCategoryViewModel>: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    
    private var title: String {
        viewModel.category != nil ? viewModel.category?.name ?? "" : viewModel.brand?.name ?? ""
    }

    var body: some View {
        buildContentView()
            .navigationBar(title: title, backButtonTitle: "", presentationMode: presentationMode, trailing: {})
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
