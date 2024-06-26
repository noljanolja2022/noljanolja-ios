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
    func chatSettingViewModel(openConversation user: User)
    func chatSettingViewModelLeaveChat()
}

// MARK: - ChatSettingViewModel

final class ChatSettingViewModel: ViewModel {
    // MARK: State

    @Published var contentModel: ChatSettingContentModel?

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<ChatSettingAlertActionType>? {
        didSet {
            isPresentingSubject.send(alertState != nil)
        }
    }

    // MARK: Navigations

    @Published var navigationType: ChatSettingNavigationType?
    @Published var fullScreenCoverType: ChatSettingFullScreenCoverType? {
        willSet {
            guard newValue != nil else { return }
            isPresentingSubject.send(true)
        }
    }

    let isPresentingSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: Action

    let closeAction = PassthroughSubject<Void, Never>()
    let alertStateAction = PassthroughSubject<AlertState<ChatSettingAlertActionType>, Never>()
    let checkLeaveAction = PassthroughSubject<Void, Never>()
    let leaveAction = PassthroughSubject<Void, Never>()
    let assignAdminAction = PassthroughSubject<User, Never>()
    let removeParticipantAction = PassthroughSubject<User, Never>()

    // MARK: Dependencies

    let conversationSubject: CurrentValueSubject<Conversation, Never>

    private let userUseCases: UserUseCases
    private let conversationUseCases: ConversationUseCases
    private weak var delegate: ChatSettingViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = PassthroughSubject<User, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(conversation: Conversation,
         userUseCases: UserUseCases = UserUseCasesImpl.default,
         conversationUseCases: ConversationUseCases = ConversationUseCasesImpl.default,
         delegate: ChatSettingViewModelDelegate? = nil) {
        self.conversationSubject = CurrentValueSubject<Conversation, Never>(conversation)
        self.userUseCases = userUseCases
        self.conversationUseCases = conversationUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureActions()
        configurePresentation()
        configureLoadData()
    }

    private func configureBindData() {
        Publishers.CombineLatest(
            conversationSubject.removeDuplicates(),
            currentUserSubject.removeDuplicates()
        )
        .map {
            ChatSettingItemModelBuilder(conversation: $0, currentUser: $1).build()
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in
            self?.contentModel = $0
        }
        .store(in: &cancellables)
    }

    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationUseCases
                    .getConversation(conversationID: self.conversationSubject.value.id)
            }
            .sink { [weak self] result in
                switch result {
                case let .success(conversation):
                    self?.conversationSubject.send(conversation)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)

        userUseCases.getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in
                self?.currentUserSubject.send($0)
            })
            .store(in: &cancellables)
    }

    private func configureActions() {
        assignAdminAction
            .withLatestFrom(conversationSubject) { ($1, $0) }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] conversation, user in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationUseCases
                    .assignAdmin(conversationID: conversation.id, admin: user)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    break
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)

        removeParticipantAction
            .withLatestFrom(conversationSubject) { ($1, $0) }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] conversation, user in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationUseCases
                    .removeParticipant(conversationID: conversation.id, participants: [user])
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    break
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)

        let (confirmLeaveAction, leaveAlertAction) = checkLeaveAction
            .withLatestFrom(Publishers.CombineLatest(conversationSubject, currentUserSubject))
            .partition { conversation, currentUser in
                conversation.admin.id != currentUser.id
            }

        confirmLeaveAction
            .sink { [weak self] _ in
                self?.alertState = AlertState(
                    title: TextState(L10n.editChatWarningLeaveTitle),
                    message: TextState(L10n.editChatWarningLeaveDescription),
                    primaryButton: .destructive(TextState(L10n.commonDisagree.uppercased())),
                    secondaryButton: .default(TextState(L10n.commonAgree.uppercased()), action: .send(.leave))
                )
            }
            .store(in: &cancellables)

        leaveAlertAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.alertState = AlertState(
                    title: TextState(""),
                    message: TextState("Please assign another one to admin first"),
                    dismissButton: .cancel(TextState("OK"))
                )
            }
            .store(in: &cancellables)

        leaveAction
            .withLatestFrom(conversationSubject)
            .flatMapLatestToResult { [weak self] conversation in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationUseCases.leave(conversationID: conversation.id)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    self.closeAction.send()
                    self.delegate?.chatSettingViewModelLeaveChat()
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }

    private func configurePresentation() {
        alertStateAction
            .flatMapLatest { [weak self] alertState -> AnyPublisher<AlertState<ChatSettingAlertActionType>, Never> in
                guard let self else {
                    return Empty<AlertState<ChatSettingAlertActionType>, Never>()
                        .eraseToAnyPublisher()
                }
                return self.isPresentingSubject
                    .filter { !$0 }
                    .first()
                    .mapToValue(alertState)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.alertState = $0
            }
            .store(in: &cancellables)
    }
}

// MARK: ParticipantDetailActionViewModelDelegate

extension ChatSettingViewModel: ParticipantDetailActionViewModelDelegate {
    func participantDetailActionViewModel(didSelect user: User, action: ParticipantDetailActionType) {
        switch action {
        case let .chat(user):
            delegate?.chatSettingViewModel(openConversation: user)
        case .assignAdmin:
            assignAdminAction.send(user)
        case .blockUser:
            break
        case .removeParticipant:
            let alertState = AlertState<ChatSettingAlertActionType>(
                title: TextState(L10n.editChatWarningRemoveTitle),
                message: TextState(L10n.editChatWarningRemoveDescription),
                primaryButton: .destructive(TextState(L10n.commonDisagree.uppercased())),
                secondaryButton: .default(TextState(L10n.commonAgree.uppercased()), action: .send(.removeParticipant(user)))
            )
            alertStateAction.send(alertState)
        }
    }
}
