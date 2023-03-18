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

// MARK: - ContactListViewModelType

protocol ContactListViewModelType:
    ViewModelType where State == ContactListViewModel.State, Action == ContactListViewModel.Action {}

extension ContactListViewModel {
    struct State {
        var searchString = ""
        var users = [User]()
        var error: Error?

        var isProgressHUDShowing = false
        var viewState = ViewState.content
    }

    enum Action {
        case loadData
        case requestContactsPermission
        case openAppSetting
        case createConversation(User)
    }
}

// MARK: - ContactListViewModel

final class ContactListViewModel: ContactListViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let contactService: ContactServiceType
    private let conversationService: ConversationServiceType
    private weak var delegate: ContactListViewModelDelegate?

    // MARK: Action

    private let loadDataTrigger = PassthroughSubject<Void, Never>()
    private let requestContactsPermissionTrigger = PassthroughSubject<Void, Never>()
    private let createConversationTrigger = PassthroughSubject<User, Never>()

    // MARK: Private

    private var allUsers = [User]()
    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         contactService: ContactServiceType = ContactService.default,
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: ContactListViewModelDelegate? = nil) {
        self.state = state
        self.contactService = contactService
        self.conversationService = conversationService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            loadDataTrigger.send()
        case .requestContactsPermission:
            requestContactsPermissionTrigger.send()
        case .openAppSetting:
            guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case let .createConversation(user):
            createConversationTrigger.send(user)
        }
    }

    private func configure() {
        loadDataTrigger
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.state.viewState = .loading })
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
                        return self.contactService.getContacts()
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case let .success(users):
                    logger.info("Get contacts successful")
                    self.allUsers = users
                    self.state.users = users
                    self.state.viewState = .content
                case let .failure(error):
                    logger.error("Get contacts failed: \(error.localizedDescription)")
                    self.state.error = error
                    self.state.viewState = .error
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
                    self?.state.error = error
                    self?.state.viewState = .error
                }
            })
            .store(in: &cancellables)

        $state
            .map(\.searchString)
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
            .sink(receiveValue: { [weak self] in self?.state.users = $0 })
            .store(in: &cancellables)

        createConversationTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.state.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] user -> AnyPublisher<Conversation, Error> in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .createConversation(title: "Conversation", type: .single, participants: [user])
            }
            .sink(receiveValue: { [weak self] result in
                self?.state.isProgressHUDShowing = false
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
