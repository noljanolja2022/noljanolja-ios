
//
//  ListGiftCategoryViewModel.swift
//  Noljanolja
//
//  Created by duydinhv on 20/11/2023.
//

// MARK: - ListGiftCategoryViewModelDelegate

protocol ListGiftCategoryViewModelDelegate: AnyObject {}

// MARK: - ListGiftCategoryViewModel

final class ListGiftCategoryViewModel: ViewModel {
    let category: GiftCategory
    
    init(category: GiftCategory) {
        self.category = category
    }
}
