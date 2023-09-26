//
//  HomeFriendViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/09/2023.
//
//

import Combine
import Foundation

// MARK: - HomeFriendViewModelDelegate

protocol HomeFriendViewModelDelegate: AnyObject {}

// MARK: - HomeFriendViewModel

final class HomeFriendViewModel: ViewModel {
    // MARK: State

    @Published var selectedUsers = [User]()

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: HomeFriendViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: HomeFriendViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
