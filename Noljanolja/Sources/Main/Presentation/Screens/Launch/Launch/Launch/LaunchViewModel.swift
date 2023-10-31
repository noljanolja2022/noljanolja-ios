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
    func launchViewModelDidComplete(_ user: User?)
}

// MARK: - LaunchViewModel

final class LaunchViewModel: ViewModel {
    // MARK: State

    @Published var isContinueButtonHidden = true

    // MARK: Action

    let navigateToAuthAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private var userDefaults: UserDefaultsType
    private let authUseCases: AuthUseCases
    private let userUseCases: UserUseCases
    private weak var delegate: LaunchViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(userDefaults: UserDefaultsType = UserDefaults.standard,
         authUseCases: AuthUseCases = AuthUseCasesImpl.default,
         userUseCases: UserUseCases = UserUseCasesImpl.default,
         delegate: LaunchViewModelDelegate? = nil) {
        self.userDefaults = userDefaults
        self.authUseCases = authUseCases
        self.userUseCases = userUseCases
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
                    if self.userDefaults.isFirstLaunch {
                        self.userDefaults.isFirstLaunch = false
                        return self.authUseCases.signOut()
                    } else {
                        return Just(())
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }
                }()
                return trigger
                    .flatMap { _ in self.authUseCases.getIDTokenResult() }
                    .flatMap { _ in self.userUseCases.getCurrentUser() }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(user):
                    self?.delegate?.launchViewModelDidComplete(user)
                case .failure:
                    self?.isContinueButtonHidden = false
                }
            })
            .store(in: &cancellables)

        navigateToAuthAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.launchViewModelDidComplete(nil)
            }
            .store(in: &cancellables)
    }
}
