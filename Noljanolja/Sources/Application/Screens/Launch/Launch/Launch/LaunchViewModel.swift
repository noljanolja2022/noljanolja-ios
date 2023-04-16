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
    func navigateToUpdateCurrentUser()
    func navigateToMain()
}

// MARK: - LaunchViewModel

final class LaunchViewModel: ViewModel {
    // MARK: State

    @Published var isContinueButtonHidden = true

    // MARK: Action

    let navigateToAuthAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private var userDefaults: UserDefaultsType
    private let authService: AuthServiceType
    private let userService: UserServiceType
    private weak var delegate: LaunchViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(userDefaults: UserDefaultsType = UserDefaults.standard,
         authService: AuthServiceType = AuthService.default,
         userService: UserServiceType = UserService.default,
         delegate: LaunchViewModelDelegate? = nil) {
        self.userDefaults = userDefaults
        self.authService = authService
        self.userService = userService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .first(where: { $0 })
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
                    .flatMap { _ in self.userService.getCurrentUser() }
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(user):
                    logger.info("Get pre data successful")
                    if user.isSettedUp {
                        self?.delegate?.navigateToMain()
                    } else {
                        self?.delegate?.navigateToUpdateCurrentUser()
                    }
                case let .failure(error):
                    logger.error("Get pre data failed - \(error.localizedDescription)")
                    self?.isContinueButtonHidden = false
                }
            })
            .store(in: &cancellables)

        navigateToAuthAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.navigateToAuth()
            }
            .store(in: &cancellables)
    }
}
