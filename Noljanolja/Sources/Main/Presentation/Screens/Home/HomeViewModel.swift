//
//  MainViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import SwiftUIX

// MARK: - HomeViewModelDelegate

protocol HomeViewModelDelegate: AnyObject {
    func homeViewModelSignOut()
}

// MARK: - HomeViewModel

final class HomeViewModel: ViewModel {
    // MARK: State

    let tabs: [HomeTabType] = [.watch, .chat, .wallet, .shop, .friends]
    @Published var isProgressHUDShowing = false
    @Published var selectedTab = HomeTabType.friends
    @Published var tabNews = [HomeTabType: Bool]()
    @Published var alertState: AlertState<HomeAlertActionType>?

    // MARK: Navigations

    @Published var navigationType: HomeNavigationType?
    @Published var fullScreenCoverType: HomeScreenCoverType?

    // MARK: Action

    // MARK: Dependencies

    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let userUseCases: UserUseCases
    private let bannerNetworkRepository: BannerNetworkRepository
    private weak var delegate: HomeViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(userUseCases: UserUseCases = UserUseCasesImpl.default,
         bannerNetworkRepository: BannerNetworkRepository = BannerNetworkRepositoryImpl.shared,
         delegate: HomeViewModelDelegate? = nil) {
        self.userUseCases = userUseCases
        self.bannerNetworkRepository = bannerNetworkRepository
        self.delegate = delegate
        super.init()

        configure()
        binding()
    }

    private func binding() {
        UserDefaults.standard.publisher(for: \.chatSingleIdNoti)
            .combineLatest(isAppearSubject)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] conversationId, isAppearSubject in
                guard let self, isAppearSubject, conversationId != 0 else { return }
                self.navigationType = .chat(conversationId)
                UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.chatSingleIdNoti)
            }
            .store(in: &cancellables)
    }

    private func configure() {
        switch Natrium.Config.environment {
        case .development:
            configureForDevelopment()
        case .production:
            configureForProduction()
        }
    }

    private func configureForDevelopment() {
        configureNotificationPermission()
        configureLoadData()
        configureActions()
    }

    private func configureForProduction() {
        let user: User? = userUseCases.getCurrentUser()
        if user?.isTesting == true {
            configureForDevelopment()
        } else {
            alertState = AlertState(
                title: TextState(""),
                message: TextState(L10n.comingSoonDescription),
                dismissButton: .cancel(
                    TextState(L10n.commonExit),
                    action: .send(.exitApp)
                )
            )
        }
    }

    private func configureNotificationPermission() {
        isAppearSubject
            .filter { $0 }
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.userNotificationCenter.getNotificationSettings { [weak self] notificationSettings in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        switch notificationSettings.authorizationStatus {
                        case .notDetermined:
                            self.userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
                        case .denied:
                            withoutAnimation {
                                self.fullScreenCoverType = .notificationSetting
                            }
                        case .authorized, .provisional, .ephemeral:
                            break
                        @unknown default:
                            break
                        }
                    }
                }
            }
            .store(in: &cancellables)
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
                return self.bannerNetworkRepository.getBanners()
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
    func conversationListViewModelSignOut() {
        delegate?.homeViewModelSignOut()
    }

    func conversationListViewModel(hasUnseenConversations: Bool) {
        tabNews[.chat] = hasUnseenConversations
    }
}

// MARK: WalletViewModelDelegate

extension HomeViewModel: WalletViewModelDelegate {
    func walletViewModelGoShop() {
        selectedTab = .shop
    }

    func walletViewModelSignOut() {
        delegate?.homeViewModelSignOut()
    }
}

// MARK: AddFriendsHomeViewModelDelegate

extension HomeViewModel: AddFriendsHomeViewModelDelegate {}

// MARK: HomeFriendViewModelDelegate

extension HomeViewModel: HomeFriendViewModelDelegate {
    func homeFriendViewModelSignOut() {
        delegate?.homeViewModelSignOut()
    }
}

// MARK: ShopHomeViewModelDelegate

extension HomeViewModel: ShopHomeViewModelDelegate {
    func shopHomeViewModelSignOut() {
        delegate?.homeViewModelSignOut()
    }
}

// MARK: VideosViewModelDelegate

// MARK:

extension HomeViewModel: VideosViewModelDelegate {
    func videosViewModelSignOut() {
        delegate?.homeViewModelSignOut()
    }
}

// MARK: ChatViewModelDelegate

extension HomeViewModel: ChatViewModelDelegate {
    func chatViewModel(openConversation user: User) {}
}
