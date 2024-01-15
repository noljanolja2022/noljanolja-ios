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
    @Published var model: [NotificationsModel?] = []

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private var cancellables = Set<AnyCancellable>()
    private weak var delegate: FriendNotificationViewModeDelegate?

    init(navigationType: FriendNotificationNavigationType? = nil, delegate: FriendNotificationViewModeDelegate? = nil) {
        self.navigationType = navigationType
        self.delegate = delegate
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
                .mapToVoid())
        
        loadDataAction
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapToResult { [weak self] _ -> AnyPublisher<[NotificationsModel], Error> in
                guard let self else {
                    return Empty<[NotificationsModel], Error>().eraseToAnyPublisher()
                }
                return NotificationNetworkRepositoryImpl.shared.getNotificaionts(page: 1, pageSize: 20)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.model = model
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
