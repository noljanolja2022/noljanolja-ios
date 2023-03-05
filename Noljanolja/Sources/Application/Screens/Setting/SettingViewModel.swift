//
//  SettingViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import Foundation

// MARK: - SettingViewModelDelegate

protocol SettingViewModelDelegate: AnyObject {
    func didSignOut()
}

// MARK: - SettingViewModelType

protocol SettingViewModelType:
    ViewModelType where State == SettingViewModel.State, Action == SettingViewModel.Action {}

extension SettingViewModel {
    struct State {}

    enum Action {
        case signOut
    }
}

// MARK: - SettingViewModel

final class SettingViewModel: SettingViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let authService: AuthServicesType
    private weak var delegate: SettingViewModelDelegate?

    // MARK: Action

    private let signOutTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         authService: AuthServicesType = AuthServices.default,
         delegate: SettingViewModelDelegate? = nil) {
        self.state = state
        self.authService = authService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .signOut:
            signOutTrigger.send()
        }
    }

    private func configure() {
        signOutTrigger
            .flatMap { [weak self] in
                guard let self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                return self.authService.signOut()
            }
            .eraseToResultAnyPublisher()
            .sink(receiveValue: { [weak self] _ in
                self?.delegate?.didSignOut()
            })
            .store(in: &cancellables)
    }
}
