//
//  UpdateProfileViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/03/2023.
//
//

import Combine

// MARK: - UpdateProfileViewModelDelegate

protocol UpdateProfileViewModelDelegate: AnyObject {}

// MARK: - UpdateProfileViewModelType

protocol UpdateProfileViewModelType:
    ViewModelType where State == UpdateProfileViewModel.State, Action == UpdateProfileViewModel.Action {}

extension UpdateProfileViewModel {
    struct State {}

    enum Action {}
}

// MARK: - UpdateProfileViewModel

final class UpdateProfileViewModel: UpdateProfileViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: UpdateProfileViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: UpdateProfileViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_: Action) {}

    private func configure() {}
}
