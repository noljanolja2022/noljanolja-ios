//
//  FriendNotificationViewModel.swift
//  Noljanolja
//
//  Created by Duy Dinh on 15/01/2024.
//

import Combine
import Foundation
import SwiftUIX

// MARK: - FriendNotificationViewModeDelegate

protocol FriendNotificationViewModeDelegate: AnyObject {}

// MARK: - FriendNotificationViewModel

final class FriendNotificationViewModel: ViewModel {
    // MARK: Navigation

    @Published var navigationType: FriendNotificationNavigationType?
    let isPresentingSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var footerState = StatefullFooterViewState.normal
    @Published var models: [FriendNotificationSectionModel] = []
    @Published var users: [User] = []

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private var cancellables = Set<AnyCancellable>()
    private weak var delegate: FriendNotificationViewModeDelegate?

    init(navigationType: FriendNotificationNavigationType? = nil, delegate: FriendNotificationViewModeDelegate? = nil, users: [User] = []) {
        self.navigationType = navigationType
        self.delegate = delegate
        self.users = users
        super.init()

        configure()
        configActions()
    }

    private func configure() {}

    private func configActions() {
        let loadDataAction = Publishers.Merge(
            isAppearSubject
                .receive(on: DispatchQueue.main)
                .first()
                .mapToVoid(),
            loadMoreAction
                .receive(on: DispatchQueue.main)
                .filter { [weak self] in
                    self?.footerState.isLoadEnabled ?? false
                }
                .mapToVoid()
        )

        loadDataAction
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapToResult { _ -> AnyPublisher<[NotificationsModel], Error> in
                NotificationNetworkRepositoryImpl.shared.getNotificaionts(page: 1, pageSize: 100)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    var newSection = FriendNotificationSectionModel(header: .new, items: [])
                    var previousSection = FriendNotificationSectionModel(header: .previous, items: [])
                    model.forEach { notificationModel in
                        let avatar = self.users.first(where: { $0.id == notificationModel.userID })?.avatar
                        if notificationModel.isRead {
                            newSection.items.append(FriendNotificationItemModel(model: notificationModel, avatar: avatar))
                        } else {
                            previousSection.items.append(FriendNotificationItemModel(model: notificationModel, avatar: avatar))
                        }
                    }
                    let sectionModels = [newSection, previousSection].filter { !$0.items.isEmpty }
                    self.models = sectionModels
                    self.viewState = .content
                    self.footerState = self.models.isEmpty ? .noMoreData : .normal
                case .failure:
                    self.viewState = .error
                    self.footerState = .error
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: FriendNotificationViewModeDelegate

extension FriendNotificationViewModel: FriendNotificationViewModeDelegate {}
