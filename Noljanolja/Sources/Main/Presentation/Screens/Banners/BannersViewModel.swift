//
//  BannersViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/06/2023.
//
//

import Combine
import Foundation

// MARK: - BannersViewModelDelegate

protocol BannersViewModelDelegate: AnyObject {}

// MARK: - BannersViewModel

final class BannersViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    let banners: [Banner]
    private weak var delegate: BannersViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(banners: [Banner],
         delegate: BannersViewModelDelegate? = nil) {
        self.banners = banners
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
