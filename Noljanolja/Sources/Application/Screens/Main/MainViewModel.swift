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
    func mainViewModelSignOut()
}

// MARK: - MainViewModel

final class MainViewModel: ViewModel {
    // MARK: State

    @Published var selectedTab = MainTabType.chat
    @Published var tabNews = [MainTabType: Bool]()

    // MARK: Navigations

    @Published var navigationType: MainNavigationType?

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: MainViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: MainViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}

// MARK: ConversationListViewModelDelegate

extension MainViewModel: ConversationListViewModelDelegate {
    func conversationListViewModel(hasUnseenConversations: Bool) {
        tabNews[.chat] = hasUnseenConversations
    }
}

// MARK: WalletViewModelDelegate

extension MainViewModel: WalletViewModelDelegate {
    func walletViewModelSignOut() {
        delegate?.mainViewModelSignOut()
    }
}

// MARK: AddFriendsViewModelDelegate

extension MainViewModel: AddFriendsViewModelDelegate {}
