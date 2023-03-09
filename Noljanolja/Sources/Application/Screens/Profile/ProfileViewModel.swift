//
//  ProfileViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Combine
import Foundation

// MARK: - ProfileViewModelDelegate

protocol ProfileViewModelDelegate: AnyObject {
    func didSignOut()
}

// MARK: - ProfileViewModelType

protocol ProfileViewModelType: SettingViewModelDelegate,
    ViewModelType where State == ProfileViewModel.State, Action == ProfileViewModel.Action {}

extension ProfileViewModel {
    struct State {
        var user: User?
        var error: Error?
        var viewState: ViewState = .content
    }

    enum Action {
        case loadData
    }
}

// MARK: - ProfileViewModel

final class ProfileViewModel: ProfileViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let profileService: ProfileServiceType
    private weak var delegate: ProfileViewModelDelegate?

    // MARK: Action

    private let loadDataTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         profileService: ProfileServiceType = ProfileService.default,
         delegate: ProfileViewModelDelegate? = nil) {
        self.state = state
        self.profileService = profileService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData: loadDataTrigger.send()
        }
    }

    private func configure() {
        loadDataTrigger
            .handleEvents(receiveOutput: { [weak self] in self?.state.viewState = .loading })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                return self.profileService.getProfileIfNeeded()
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(user):
                    logger.info("Get profile successful")
                    self?.state.user = user
                    self?.state.viewState = .content
                case let .failure(error):
                    logger.error("Get profile successful")
                    self?.state.error = error
                    self?.state.viewState = .error
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: SettingViewModelDelegate

extension ProfileViewModel: SettingViewModelDelegate {
    func didSignOut() {
        delegate?.didSignOut()
    }
}
