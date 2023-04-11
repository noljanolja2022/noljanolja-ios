//
//  ChatSettingViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/04/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ChatSettingViewModelDelegate

protocol ChatSettingViewModelDelegate: AnyObject {
    func didLeaveGroupChat()
}

// MARK: - ChatSettingViewModel

final class ChatSettingViewModel: ViewModel {
    // MARK: State
    
    @Published var isAddParticipantsEnabled = false
    @Published var participantModels = [ChatSettingParticipantModel]()
    @Published var settingItems = [ChatSettingItemModel]()

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Navigations

    @Published var navigationType: ChatSettingNavigationType?
    @Published var fullScreenCoverType: ChatSettingFullScreenCoverType?

    // MARK: Action

    let closeAction = PassthroughSubject<Void, Never>()
    let leaveAction = PassthroughSubject<Void, Never>()
    let assignAdminAction = PassthroughSubject<User, Never>()
    let removeParticipantAction = PassthroughSubject<User, Never>()

    // MARK: Dependencies

    let conversationSubject: CurrentValueSubject<Conversation, Never>

    private let userService: UserServiceType
    private let conversationService: ConversationServiceType
    private weak var delegate: ChatSettingViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()

    init(conversation: Conversation,
         userService: UserServiceType = UserService.default,
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: ChatSettingViewModelDelegate? = nil) {
        self.conversationSubject = CurrentValueSubject<Conversation, Never>(conversation)
        self.userService = userService
        self.conversationService = conversationService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureLoadData()
        configureActions()
    }

    private func configureBindData() {
        Publishers.CombineLatest(
            conversationSubject.removeDuplicates(),
            currentUserSubject.removeDuplicates()
        )
        .sink { [weak self] conversation, currentUser in
            if conversation.admin.id == currentUser?.id {
                self?.settingItems = [.updateTitle]
            } else {
                self?.settingItems = []
            }
        }
        .store(in: &cancellables)
    }

    private func configureLoadData() {
        Publishers.CombineLatest(
            conversationSubject.removeDuplicates(),
            currentUserSubject.compactMap { $0 }.removeDuplicates()
        )
        .sink { [weak self] (conversation: Conversation, currentUser: User) in
            let adminAndCurrentParticipants = conversation.participants
                .filter {
                    $0.id == conversation.admin.id
                        && $0.id == currentUser.id
                }
            let adminParticipants = conversation.participants
                .filter {
                    $0.id == conversation.admin.id
                        && $0.id != currentUser.id
                }
            let currentParticipants = conversation.participants
                .filter {
                    $0.id != conversation.admin.id
                        && $0.id == currentUser.id
                }
            let otherParticipants = conversation.participants
                .filter {
                    $0.id != conversation.admin.id
                        && $0.id != currentUser.id
                }
                .sorted(currentUser: currentUser)

            self?.isAddParticipantsEnabled = conversation.admin.id == currentUser.id
            self?.participantModels = (adminAndCurrentParticipants + adminParticipants + currentParticipants + otherParticipants)
                .map { user in
                    ChatSettingParticipantModel(user: user, currentUser: currentUser, admin: conversation.admin)
                }
        }
        .store(in: &cancellables)

        userService.currentUserPublisher
            .sink(receiveValue: { [weak self] in
                self?.currentUserSubject.send($0)
            })
            .store(in: &cancellables)

        isAppearSubject
            .filter { $0 }
            .first()
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .getConversation(conversationID: self.conversationSubject.value.id)
            }
            .sink { [weak self] result in
                switch result {
                case let .success(conversation):
                    logger.info("Get conversation successful")
                    self?.conversationSubject.send(conversation)
                case let .failure(error):
                    logger.error("Get conversation failed: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }

    private func configureActions() {
        assignAdminAction
            .withLatestFrom(conversationSubject) { ($1, $0) }
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] conversation, user in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .assignAdmin(conversationID: conversation.id, admin: user)
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    logger.info("Assign admin successful")
                case let .failure(error):
                    logger.error("Assign admin failed: \(error.localizedDescription)")
                    self.alertState = AlertState(
                        title: TextState("Error"),
                        message: TextState(L10n.Common.Error.message),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)

        removeParticipantAction
            .withLatestFrom(conversationSubject) { ($1, $0) }
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] conversation, user in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .removeParticipant(conversationID: conversation.id, participants: [user])
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    logger.info("Remove participant successful")
                case let .failure(error):
                    logger.error("Remove participant failed: \(error.localizedDescription)")
                    self.alertState = AlertState(
                        title: TextState("Error"),
                        message: TextState(L10n.Common.Error.message),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)

        leaveAction
            .withLatestFrom(currentUserSubject)
            .compactMap { $0 }
            .withLatestFrom(conversationSubject) { ($1, $0) }
            .flatMapLatestToResult { [weak self] conversation, currentUser in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .removeParticipant(conversationID: conversation.id, participants: [currentUser])
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    logger.info("Leave successful")
                    self.closeAction.send()
                    self.delegate?.didLeaveGroupChat()
                case let .failure(error):
                    logger.error("Leave failed: \(error.localizedDescription)")
                    self.alertState = AlertState(
                        title: TextState("Error"),
                        message: TextState(L10n.Common.Error.message),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: ChatSettingParticipantDetailViewModelDelegate

extension ChatSettingViewModel: ChatSettingParticipantDetailViewModelDelegate {
    func didSelectAction(user: User, action: ChatSettingUserDetailAction) {
        switch action {
        case .assignAdmin: assignAdminAction.send(user)
        case .removeParticipant: removeParticipantAction.send(user)
        }
    }
}
