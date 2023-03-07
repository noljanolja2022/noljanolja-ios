//
//  MainViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Combine
import Foundation

// MARK: - MainViewModelDelegate

protocol MainViewModelDelegate: AnyObject {
    func didSignOut()
}

// MARK: - MainViewModelType

protocol MainViewModelType: ProfileViewModelDelegate,
    ViewModelType where State == MainViewModel.State, Action == MainViewModel.Action {}

extension MainViewModel {
    struct State {
        enum Tab: String {
            case chat = "Chat"
            case events = "Events"
            case content = "Content"
            case shop = "Shop"
            case profile = "Profile"
        }

        var selectedTab = Tab.chat
    }

    enum Action {}
}

// MARK: - MainViewModel

final class MainViewModel: MainViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: MainViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: MainViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_: Action) {}

    private func configure() {}
}

// MARK: ProfileViewModelDelegate

extension MainViewModel: ProfileViewModelDelegate {
    func didSignOut() {
        delegate?.didSignOut()
    }
}
