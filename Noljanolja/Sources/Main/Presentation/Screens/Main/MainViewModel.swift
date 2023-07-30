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

    @Published var isProgressHUDShowing = false
    @Published var selectedTab = MainTabType.chat
    @Published var tabNews = [MainTabType: Bool]()

    // MARK: Navigations

    @Published var navigationType: MainNavigationType?
    @Published var fullScreenCoverType: MainScreenCoverType?

    // MARK: Action

    // MARK: Dependencies

    private let bannerRepository: BannerRepository
    private weak var delegate: MainViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(bannerRepository: BannerRepository = BannerRepositoryImpl.shared,
         delegate: MainViewModelDelegate? = nil) {
        self.bannerRepository = bannerRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
    }

    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<PaginationResponse<[Banner]>, Error>().eraseToAnyPublisher()
                }
                return self.bannerRepository.getBanners()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    guard !model.data.isEmpty else { return }
                    self.fullScreenCoverType = .banners(model.data)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
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

// MARK: AddFriendsHomeViewModelDelegate

extension MainViewModel: AddFriendsHomeViewModelDelegate {}
