//
//  ChatSettingViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/04/2023.
//
//

import Combine
import Foundation

// MARK: - ChatSettingViewModelDelegate

protocol ChatSettingViewModelDelegate: AnyObject {}

// MARK: - ChatSettingViewModel

final class ChatSettingViewModel: ViewModel {
    // MARK: State

    @Published var isAddParticipantsEnabled = false
    @Published var participantModels = [ChatSettingParticipantModel]()

    // MARK: Action

    // MARK: Navigation

    @Published var navigationType: ChatSettingNavigationType?
    @Published var fullScreenCoverType: ChatSettingFullScreenCoverType?

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
        configureLoadData()
    }

    private func configureLoadData() {
        Publishers.CombineLatest(conversationSubject, currentUserSubject)
            .sink { [weak self] conversation, currentUser in
                let models = conversation.participants
                    .map { user in
                        ChatSettingParticipantModel(user: user, currentUser: currentUser, admin: conversation.admin)
                    }

                let adminAndCurrentUserModels = models.filter { $0.isAdmin && $0.isCurrentUser }
                let adminModels = models.filter { $0.isAdmin && !$0.isCurrentUser }
                let currentModels = models.filter { !$0.isAdmin && $0.isCurrentUser }
                let otherUser = models
                    .filter { !$0.isAdmin && !$0.isCurrentUser }
                    .sorted(by: { $0.user.name ?? "" < $1.user.name ?? "" })

                self?.isAddParticipantsEnabled = conversation.creator.id == currentUser?.id
                self?.participantModels = adminAndCurrentUserModels + adminModels + currentModels + otherUser
            }
            .store(in: &cancellables)

        userService.currentUserPublisher
            .sink(receiveValue: { [weak self] in
                self?.currentUserSubject.send($0)
            })
            .store(in: &cancellables)

        conversationService
            .getConversation(conversationID: conversationSubject.value.id)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.conversationSubject.send($0) }
            )
            .store(in: &cancellables)
    }
}
