//
//  MainViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/02/2023.
//
//

import Combine

// MARK: - MainViewModelDelegate

protocol MainViewModelDelegate: AnyObject {}

// MARK: - MainViewModelType

protocol MainViewModelType: ObservableObject, AuthPopupViewModelDelegate {
    // MARK: State

    var selectedTabItem: TabBarItem { get set }

    var navigationType: MainNavigationType? { get set }

    // MARK: Action

    var selectedTabItemTrigger: PassthroughSubject<TabBarItem, Never> { get }
}

// MARK: - MainViewModel

final class MainViewModel: MainViewModelType {
    // MARK: Dependencies

    private weak var delegate: MainViewModelDelegate?
    private let authService: AuthServicesType

    // MARK: State

    @Published var selectedTabItem: TabBarItem = .chat

    @Published var navigationType: MainNavigationType? = nil

    // MARK: Action

    let selectedTabItemTrigger = PassthroughSubject<TabBarItem, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: MainViewModelDelegate? = nil,
         authService: AuthServicesType = AuthServices.default) {
        self.delegate = delegate
        self.authService = authService

        configure()
    }

    private func configure() {}
}

// MARK: AuthPopupViewModelDelegate

extension MainViewModel: AuthPopupViewModelDelegate {
    func routeToAuth() {
        navigationType = .auth
    }
}
