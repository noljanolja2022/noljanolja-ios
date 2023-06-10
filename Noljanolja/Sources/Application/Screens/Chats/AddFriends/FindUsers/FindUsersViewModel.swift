//
//  FindUsersViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - FindUsersViewModelDelegate

protocol FindUsersViewModelDelegate: AnyObject {
    func findUsersViewModel(didFind users: [User])
}

// MARK: - FindUsersViewModel

final class FindUsersViewModel: ViewModel {
    // MARK: State
    
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Action

    // MARK: Dependencies

    private let findUserModelTypePublisher: AnyPublisher<FindUsersModelType, Never>
    private let userAPI: UserAPIType
    private weak var delegate: FindUsersViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(findUserModelTypePublisher: AnyPublisher<FindUsersModelType, Never>,
         userAPI: UserAPIType = UserAPI.default,
         delegate: FindUsersViewModelDelegate? = nil) {
        self.findUserModelTypePublisher = findUserModelTypePublisher
        self.userAPI = userAPI
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureActions()
    }

    private func configureActions() {
        findUserModelTypePublisher
            .map { modelType -> (String?, String?) in
                switch modelType {
                case let .phoneNumber(phoneNumber):
                    return (phoneNumber, nil)
                case let .id(id):
                    return (nil, id)
                }
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isProgressHUDShowing = true
            })
            .flatMapLatestToResult { [weak self] phoneNumber, userId in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.userAPI.findUsers(phoneNumber: phoneNumber, friendId: userId)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    if model.isEmpty {
                        self.alertState = AlertState(
                            title: TextState(L10n.commonErrorTitle),
                            message: TextState(L10n.addFriendPhoneNotAvailable),
                            dismissButton: .cancel(TextState(L10n.commonClose))
                        )
                    } else {
                        self.delegate?.findUsersViewModel(didFind: model)
                    }
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }
}
