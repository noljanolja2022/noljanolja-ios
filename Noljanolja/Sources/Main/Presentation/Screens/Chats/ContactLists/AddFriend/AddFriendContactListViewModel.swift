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
    enum SearchType {
        case chat
        case friend
    }

    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Navigations

    @Published var navigationType: AddFriendContactListNavigationType?

    // MARK: Action

    let searchType: SearchType
    let action = PassthroughSubject<User, Never>()
    let closeAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let addFriendsUseCase: AddFriendUseCaseType
    private weak var delegate: AddFriendContactListViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(addFriendsUseCase: AddFriendUseCaseType = AddFriendUseCase.default,
         delegate: AddFriendContactListViewModelDelegate? = nil,
         type: SearchType) {
        self.addFriendsUseCase = addFriendsUseCase
        self.delegate = delegate
        self.searchType = type
        super.init()

        configure()
    }

    private func configure() {
        configureActions()
    }

    private func configureActions() {
        let chatAction = action
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isProgressHUDShowing = true
            })
            .flatMapLatestToResult { [weak self] user in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.addFriendsUseCase.addFriend(user: user)
            }
        let friendAction = action

        Publishers.CombineLatest(chatAction, friendAction)
            .sink(receiveValue: { [weak self] result, user in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    switch self.searchType {
                    case .chat:
                        self.navigationType = .chat(model.id)
                    case .friend:
                        self.navigationType = .detail(user)
                    }

                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)
    }
}
