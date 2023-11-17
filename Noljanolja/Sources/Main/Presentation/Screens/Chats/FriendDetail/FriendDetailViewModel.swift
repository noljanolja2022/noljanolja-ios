//
//  FriendDetailViewModel.swift
//  Noljanolja
//
//  Created by duydinhv on 16/11/2023.
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - FriendDetailViewModelDelegate

protocol FriendDetailViewModelDelegate {}

// MARK: - FriendDetailViewModel

class FriendDetailViewModel: ViewModel {
    let user: User

    @Published var myPoint: Int?
    @Published var viewState = ViewState.content
    @Published var error: Error?
    @Published var isProgressHUDShowing = false
    @Published var navigationType: FriendDetailNavigationType?
    @Published var conversations = [ConversationItemModel]()

    let openChatWithUserAction = PassthroughSubject<User, Never>()

    private let conversationUseCases: ConversationUseCases
    private let conversationSocketService: ConversationSocketServiceType
    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)
    private let conversationsSubject = PassthroughSubject<[Conversation], Never>()
    private let memberInfoUseCase: MemberInfoUseCases
    private var cancellables = Set<AnyCancellable>()

    init(user: User,
         memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         conversationUseCases: ConversationUseCases = ConversationUseCasesImpl.default,
         conversationSocketService: ConversationSocketService = ConversationSocketService.default) {
        self.user = user
        self.memberInfoUseCase = memberInfoUseCase
        self.conversationUseCases = conversationUseCases
        self.conversationSocketService = conversationSocketService

        super.init()
        configure()
    }

    private func configure() {
        configureLoadData()
        configureSocket()
        configureBindData()
        configureActions()
    }

    private func configureLoadData() {
        memberInfoSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.myPoint = $0.point
            }
            .store(in: &cancellables)

        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<LoyaltyMemberInfo, Error>().eraseToAnyPublisher()
                }
                return self.memberInfoUseCase.getLoyaltyMemberInfo()
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(memberInfo):
                    self.memberInfoSubject.send(memberInfo)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)

        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<[Conversation], Error>().eraseToAnyPublisher()
                }
                return self.conversationUseCases.getConversations()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(conversations):
                    self.conversationsSubject.send(conversations)
                case let .failure(error):
                    self.error = error
                    self.viewState = .error
                }
            })
            .store(in: &cancellables)
    }
    
    private func configureSocket() {
        conversationSocketService.register()

        conversationSocketService
            .getConversationStream()
            .sink(receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    private func configureBindData() {
        conversationsSubject
            .map { conversations in
                conversations
                    .map {
                        ConversationItemModel(
                            currentUser: self.user,
                            conversation: $0
                        )
                    }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] conversationItemModels in
                self?.conversations = conversationItemModels
                self?.viewState = .content
            })
            .store(in: &cancellables)
    }
    
    private func configureActions() {
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
    }
}

// MARK: ChatViewModelDelegate

extension FriendDetailViewModel: ChatViewModelDelegate {
    func chatViewModel(openConversation user: User) {
        openChatWithUserAction.send(user)
    }
}
