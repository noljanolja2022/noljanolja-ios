//
//  MainViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Combine
import Foundation

// MARK: - HomeViewModelDelegate

protocol HomeViewModelDelegate: AnyObject {
    func mainViewModelSignOut()
}

// MARK: - HomeViewModel

final class HomeViewModel: ViewModel {
    // MARK: State

    let tabs: [HomeTabType] = [.friends, .watch, .wallet, .shop]
    @Published var isProgressHUDShowing = false
    @Published var selectedTab = HomeTabType.friends
    @Published var tabNews = [HomeTabType: Bool]()

    // MARK: Navigations

    @Published var navigationType: HomeNavigationType?
    @Published var fullScreenCoverType: HomeScreenCoverType?

    // MARK: Action

    // MARK: Dependencies

    private let bannerRepository: BannerRepository
    private weak var delegate: HomeViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(bannerRepository: BannerRepository = BannerRepositoryImpl.shared,
         delegate: HomeViewModelDelegate? = nil) {
        self.bannerRepository = bannerRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
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

    private func configureActions() {}
}

// MARK: ConversationListViewModelDelegate

extension HomeViewModel: ConversationListViewModelDelegate {
    func conversationListViewModel(hasUnseenConversations: Bool) {
        tabNews[.chat] = hasUnseenConversations
    }
}

// MARK: WalletViewModelDelegate

extension HomeViewModel: WalletViewModelDelegate {
    func walletViewModelSignOut() {
        delegate?.mainViewModelSignOut()
    }
}

// MARK: AddFriendsHomeViewModelDelegate

extension HomeViewModel: AddFriendsHomeViewModelDelegate {}
