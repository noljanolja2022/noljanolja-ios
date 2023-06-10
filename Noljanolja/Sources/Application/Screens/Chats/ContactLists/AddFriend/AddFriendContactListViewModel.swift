//
//  AddFriendContactListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - AddFriendContactListViewModelDelegate

protocol AddFriendContactListViewModelDelegate: AnyObject {}

// MARK: - AddFriendContactListViewModel

final class AddFriendContactListViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: AddFriendContactListViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: AddFriendContactListViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
