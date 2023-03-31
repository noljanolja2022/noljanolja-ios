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

final class ContactListViewModel: ObservableObject {
    // MARK: State

    @Published var searchString = ""
    @Published var users = [User]()
    @Published var selectedUsers = [User]()
    @Published var error: Error?

    @Published var isProgressHUDShowing = false
    @Published var viewState = ViewState.loading

    // MARK: Action

    let loadDataTrigger = PassthroughSubject<Void, Never>()
    let requestContactsPermissionTrigger = PassthroughSubject<Void, Never>()
    let selectUserSubject = PassthroughSubject<(ConversationType, User), Never>()
    let createConversationTrigger = PassthroughSubject<ConversationType, Never>()

    // MARK: Dependencies

    private let contactService: ContactServiceType
    private let conversationService: ConversationServiceType
    private weak var delegate: ContactListViewModelDelegate?

    // MARK: Private

    private var allUsers = [User]()
    private var cancellables = Set<AnyCancellable>()

    init(contactService: ContactServiceType = ContactService.default,
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: ContactListViewModelDelegate? = nil) {
        self.contactService = contactService
        self.conversationService = conversationService
        self.delegate = delegate

        configure()
    }

    private func configure() {
        loadDataTrigger
            .first()
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

        requestContactsPermissionTrigger
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<Bool, Error> in
                guard let self else {
                    return Empty<Bool, Error>().eraseToAnyPublisher()
                }
                return self.contactService.requestContactPermission()
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    logger.error("Request contact permission successful")
                    self?.loadDataTrigger.send()
                case let .failure(error):
                    logger.error("Request contact permission failed: \(error.localizedDescription)")
                    self?.error = error
                    self?.viewState = .error
                }
            })
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

        selectUserSubject
            .sink(receiveValue: { [weak self] createConversationType, user in
                guard let self else { return }
                switch createConversationType {
                case .single:
                    self.selectedUsers = [user]
                    self.createConversationTrigger.send(createConversationType)
                case .group:
                    if let user = self.selectedUsers.first(where: { $0.id == user.id }) {
                        self.selectedUsers = self.selectedUsers.removeAll(user)
                    } else {
                        self.selectedUsers.append(user)
                    }
                }
            })
            .store(in: &cancellables)

        createConversationTrigger
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
