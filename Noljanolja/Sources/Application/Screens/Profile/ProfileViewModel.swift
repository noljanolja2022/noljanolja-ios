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
    struct State {}

    enum Action {}
}

// MARK: - ProfileViewModel

final class ProfileViewModel: ProfileViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: ProfileViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: ProfileViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_: Action) {}

    private func configure() {}
}

// MARK: SettingViewModelDelegate

extension ProfileViewModel: SettingViewModelDelegate {
    func didSignOut() {
        delegate?.didSignOut()
    }
}
