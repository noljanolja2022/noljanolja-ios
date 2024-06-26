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

protocol HomeFriendViewModelDelegate: AnyObject {
    func homeFriendViewModelSignOut()
}

// MARK: - HomeFriendViewModel

final class HomeFriendViewModel: ViewModel {
    // MARK: Navigation

    @Published var navigationType: HomeFriendNavigationType?
    let isPresentingSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: State

    @Published var avatarURL: String?
    @Published var selectedUsers: [User] = []
    @Published var users: [User] = []

    // MARK: Action

    let navigationTypeAction = PassthroughSubject<HomeFriendNavigationType?, Never>()

    // MARK: Dependencies

    private let userUseCases: UserUseCases
    private weak var delegate: HomeFriendViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: HomeFriendViewModelDelegate? = nil,
         userUseCases: UserUseCases = UserUseCasesImpl.default) {
        self.userUseCases = userUseCases
        self.delegate = delegate
        super.init()

        configure()
        configActions()
    }

    private func configure() {
        userUseCases
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in
                self?.avatarURL = $0.avatar
            })
            .store(in: &cancellables)
    }

    private func configActions() {
        navigationTypeAction
            .flatMapLatestToResult { [weak self] navigationType in
                guard let self else {
                    return Empty<HomeFriendNavigationType?, Never>().eraseToAnyPublisher()
                }
                return self.isPresentingSubject
                    .filter { !$0 }
                    .first()
                    .map { _ in navigationType }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case let .success(navigationType):
                    self?.navigationType = navigationType
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: AddFriendsHomeViewModelDelegate

extension HomeFriendViewModel: AddFriendsHomeViewModelDelegate {}

// MARK: ProfileSettingViewModelDelegate

extension HomeFriendViewModel: ProfileSettingViewModelDelegate {
    func profileSettingViewModelSignOut() {
        delegate?.homeFriendViewModelSignOut()
    }
}
