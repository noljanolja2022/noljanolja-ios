//
//  ConversationListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import CombineExt
import Foundation
import UserNotifications

// MARK: - ConversationListViewModelDelegate

protocol ConversationListViewModelDelegate: AnyObject {
    func conversationListViewModel(hasUnseenConversations: Bool)
}

// MARK: - ConversationListViewModel

final class ConversationListViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var isProgressHUDShowing = false
    @Published var conversations = [ConversationItemModel]()
    @Published var error: Error?

    // MARK: Navigations

    @Published var navigationType: ConversationListNavigationType? {
        didSet {
            print("Noja-Debug", navigationType)
        }
    }

    @Published var fullScreenCoverType: ConversationListFullScreenCoverType? {
        willSet {
            guard newValue != nil else { return }
            isPresentingSubject.send(true)
        }
    }

    let isPresentingSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: Action

    let openChatAction = PassthroughSubject<ConversationItemModel, Never>()
    let openChatWithUserAction = PassthroughSubject<User, Never>()
    let navigationTypeAction = PassthroughSubject<ConversationListNavigationType?, Never>()

    // MARK: Dependencies

    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let userService: UserServiceType
    private let conversationService: ConversationServiceType
    private let conversationSocketService: ConversationSocketServiceType
    private weak var delegate: ConversationListViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = PassthroughSubject<User, Never>()
    private let conversationsSubject = PassthroughSubject<[Conversation], Never>()

    private var cancellables = Set<AnyCancellable>()

    init(userService: UserServiceType = UserService.default,
         conversationService: ConversationServiceType = ConversationService.default,
         conversationSocketService: ConversationSocketServiceType = ConversationSocketService.default,
         delegate: ConversationListViewModelDelegate? = nil) {
        self.userService = userService
        self.conversationService = conversationService
        self.conversationSocketService = conversationSocketService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureNotificationPermission()
        configureLoadData()
        configureSocket()
        configureActions()
    }

    private func configureBindData() {
        Publishers.CombineLatest(currentUserSubject, conversationsSubject)
            .map { currentUser, conversations in
                conversations
                    .map {
                        ConversationItemModel(
                            currentUser: currentUser,
                            conversation: $0
                        )
                    }
            }
            .sink(receiveValue: { [weak self] conversationItemModels in
                self?.conversations = conversationItemModels
                self?.viewState = .content
                self?.delegate?.conversationListViewModel(
                    hasUnseenConversations: !conversationItemModels.filter { !$0.isSeen }.isEmpty
                )
            })
            .store(in: &cancellables)
    }

    private func configureNotificationPermission() {
        isAppearSubject
            .filter { $0 }
            .first()
            .sink { [weak self] _ in
                guard let self else { return }
                self.userNotificationCenter.getNotificationSettings { [weak self] notificationSettings in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        switch notificationSettings.authorizationStatus {
                        case .notDetermined:
                            self.userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
                        case .denied:
                            self.fullScreenCoverType = .notificationSetting
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
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<[Conversation], Error>().eraseToAnyPublisher()
                }
                return self.conversationService.getConversations()
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(conversations):
                    logger.info("Get conversations successful")
                    self.conversationsSubject.send(conversations)
                case let .failure(error):
                    logger.error("Get conversations failed - \(error.localizedDescription)")
                    self.error = error
                    self.viewState = .error
                }
            })
            .store(in: &cancellables)

        userService
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)
    }

    private func configureSocket() {
        conversationSocketService.register()

        conversationSocketService
            .getConversationStream()
            .sink(receiveValue: { _ in

            })
            .store(in: &cancellables)
    }

    private func configureActions() {
        openChatAction
            .withLatestFrom(conversationsSubject) { ($0, $1) }
            .compactMap { conversationItemModel, conversations in
                conversations.first(where: { $0.id == conversationItemModel.id })
            }
            .sink(receiveValue: { [weak self] in self?.navigationType = .chat($0) })
            .store(in: &cancellables)

        openChatWithUserAction
            .withLatestFrom(conversationsSubject) { ($0, $1) }
            .compactMap { user, conversations in
                conversations
                    .first(where: { conversation in
                        switch conversation.type {
                        case .single:
                            return conversation.participants.contains(where: { $0.id == user.id })
                        case .group, .unknown:
                            return false
                        }
                    })
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] conversation in
                guard let self else { return }
                self.navigationType = nil
                self.isProgressHUDShowing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    guard let self else { return }
                    self.isProgressHUDShowing = false
                    self.navigationType = .chat(conversation)
                }
            })
            .store(in: &cancellables)

        navigationTypeAction
            .flatMapLatestToResult { [weak self] navigationType in
                guard let self else {
                    return Empty<ConversationListNavigationType?, Never>().eraseToAnyPublisher()
                }
                return self.isPresentingSubject
                    .filter { !$0 }
                    .first()
                    .map { _ in navigationType }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] result in
                switch result {
                case let .success(navigationType):
                    self?.navigationType = navigationType
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: CreateConversationContactListViewModelDelegate

extension ConversationListViewModel: CreateConversationContactListViewModelDelegate {
    func didCreateConversation(_ conversation: Conversation) {
        navigationType = .chat(conversation)
    }
}

// MARK: CreateConversationViewModelDelegate

extension ConversationListViewModel: CreateConversationViewModelDelegate {
    func didSelectType(type: ConversationType) {
        fullScreenCoverType = nil
        navigationTypeAction.send(.contactList(type))
    }
}

// MARK: ChatViewModelDelegate

extension ConversationListViewModel: ChatViewModelDelegate {
    func chatViewModel(openConversation user: User) {
        openChatWithUserAction.send(user)
    }
}
