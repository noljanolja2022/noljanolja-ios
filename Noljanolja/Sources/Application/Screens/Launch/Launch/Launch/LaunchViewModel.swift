//
//  LaunchViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//
//

import Combine
import Foundation

// MARK: - LaunchViewModelDelegate

protocol LaunchViewModelDelegate: AnyObject {
    func navigateToAuth()
    func navigateToUpdateProfile()
    func navigateToMain()
}

// MARK: - LaunchViewModelType

protocol LaunchViewModelType:
    ViewModelStateGetOnlyType where State == LaunchViewModel.State, Action == LaunchViewModel.Action {}

extension LaunchViewModel {
    struct State {
        var isContinueButtonHidden = true
    }

    enum Action {
        case loadData
        case didTapContinueButton
    }
}

// MARK: - LaunchViewModel

final class LaunchViewModel: LaunchViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private var userDefaults: UserDefaultsType
    private let authService: AuthServiceType
    private let profileService: ProfileServiceType
    private weak var delegate: LaunchViewModelDelegate?

    // MARK: Action

    private let loadDataTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         userDefaults: UserDefaultsType = UserDefaults.standard,
         authService: AuthServiceType = AuthService.default,
         profileService: ProfileServiceType = ProfileService.default,
         delegate: LaunchViewModelDelegate? = nil) {
        self.state = state
        self.userDefaults = userDefaults
        self.authService = authService
        self.profileService = profileService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            loadDataTrigger.send()
        case .didTapContinueButton:
            delegate?.navigateToAuth()
        }
    }

    private func configure() {
        loadDataTrigger
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<User, Error> in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                let trigger: AnyPublisher<Void, Error> = {
                    logger.debug("First launch app: \(self.userDefaults.isFirstLaunch)")
                    if self.userDefaults.isFirstLaunch {
                        self.userDefaults.isFirstLaunch = false
                        return self.authService.signOut()
                    } else {
                        return Just(())
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }
                }()
                return trigger
                    .flatMap { _ in self.authService.getIDTokenResult() }
                    .flatMap { _ in self.profileService.getProfile() }
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(user):
                    logger.info("Get pre data successful")
                    if user.isSetup {
                        self?.delegate?.navigateToMain()
                    } else {
                        self?.delegate?.navigateToUpdateProfile()
                    }
                case let .failure(error):
                    logger.error("Get pre data failed - \(error.localizedDescription)")
                    self?.state.isContinueButtonHidden = false
                }
            })
            .store(in: &cancellables)
    }
}
