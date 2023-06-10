//
//  FindUsersResultViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - FindUsersResultViewModelDelegate

protocol FindUsersResultViewModelDelegate: AnyObject {}

// MARK: - FindUsersResultViewModel

final class FindUsersResultViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Action

    // MARK: Dependencies

    let users: [User]
    private weak var delegate: FindUsersResultViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(users: [User],
         delegate: FindUsersResultViewModelDelegate? = nil) {
        self.users = users
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
