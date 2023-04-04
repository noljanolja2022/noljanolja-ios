//
//  ContactListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - ContactListViewModelDelegate

protocol ContactListViewModelDelegate: AnyObject {
    func didCreateConversation(_ conversation: Conversation)
}

// MARK: - ContactListViewModel

final class ContactListViewModel: ViewModel {
    // MARK: State

    @Published var searchString = ""
    @Published var users = [User]()
    @Published var error: Error?

    @Published var isProgressHUDShowing = false
    @Published var viewState = ViewState.loading

    @Published var selectedUsers = [User]()
    @Published var isCreateConversationEnabled = false

    // MARK: Action

    let requestPermissionSubject = PassthroughSubject<Void, Never>()
    let selectUserSubject = PassthroughSubject<(ConversationType, User), Never>()
    let createConversationSubject = PassthroughSubject<ConversationType, Never>()

    // MARK: Dependencies

    private let contactService: ContactServiceType
    private let conversationService: ConversationServiceType
    private weak var delegate: ContactListViewModelDelegate?

    // MARK: Private

    private let loadDataSubject = PassthroughSubject<Void, Never>()

    private var allUsers = [User]()
    
    private var cancellables = Set<AnyCancellable>()

    init(contactService: ContactServiceType = ContactService.default,
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: ContactListViewModelDelegate? = nil) {
        self.contactService = contactService
        self.conversationService = conversationService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureCreateConversation()
    }

    private func configureLoadData() {
        loadDataSubject
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.contactService
                    .getAuthorizationStatus()
                    .flatMap { [weak self] _ -> AnyPublisher<[User], Error> in
                        guard let self else {
                            return Empty<[User], Error>().eraseToAnyPublisher()
                        }
                        return self.contactService.getContacts(page: 1, pageSize: 100)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case let .success(users):
                    logger.info("Get contacts successful")
                    self.allUsers = users
                    self.users = users
                    self.viewState = .content
                case let .failure(error):
                    logger.error("Get contacts failed: \(error.localizedDescription)")
                    self.error = error
                    self.viewState = .error
                }
            })
            .store(in: &cancellables)

        requestPermissionSubject
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<Bool, Error> in
                guard let self else {
                    return Empty<Bool, Error>().eraseToAnyPublisher()
                }
                return self.contactService.requestContactPermission()
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    logger.info("Request contact permission successful")
                    self?.loadDataSubject.send()
                case let .failure(error):
                    logger.error("Request contact permission failed: \(error.localizedDescription)")
                    self?.error = error
                    self?.viewState = .error
                }
            })
            .store(in: &cancellables)

        isAppearSubject
            .filter { $0 }
            .mapToVoid().first()
            .sink(receiveValue: { [weak self] in self?.loadDataSubject.send() })
            .store(in: &cancellables)

        $searchString
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map { [weak self] text in
                let allUsers = self?.allUsers ?? []
                return allUsers
                    .filter {
                        guard !text.isEmpty else { return true }
                        return ($0.name ?? "").lowercased().contains(text.lowercased())
                            || ($0.phone ?? "").lowercased().contains(text.lowercased())
                    }
            }
            .sink(receiveValue: { [weak self] in self?.users = $0 })
            .store(in: &cancellables)
    }

    private func configureCreateConversation() {
        selectUserSubject
            .sink(receiveValue: { [weak self] createConversationType, user in
                guard let self else { return }
                switch createConversationType {
                case .single:
                    self.selectedUsers = [user]
                    self.createConversationSubject.send(createConversationType)
                case .group:
                    if let user = self.selectedUsers.first(where: { $0.id == user.id }) {
                        self.selectedUsers = self.selectedUsers.removeAll(user)
                    } else {
                        self.selectedUsers.append(user)
                    }
                    self.isCreateConversationEnabled = self.selectedUsers.isEmpty
                }
            })
            .store(in: &cancellables)

        createConversationSubject
            .withLatestFrom($selectedUsers.filter { !$0.isEmpty }) { ($0, $1) }
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] createConversationType, users -> AnyPublisher<Conversation, Error> in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .createConversation(type: createConversationType, participants: users)
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(conversation):
                    logger.info("Create conversation successful - conversation id: \(conversation.id)")
                    self?.delegate?.didCreateConversation(conversation)
                case let .failure(error):
                    logger.error("Create conversation failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
}
