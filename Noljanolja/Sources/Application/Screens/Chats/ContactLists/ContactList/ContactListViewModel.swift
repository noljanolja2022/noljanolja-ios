//
//  ContactListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//
//

import Combine
import Foundation

// MARK: - ContactListViewModelDelegate

protocol ContactListViewModelDelegate: AnyObject {}

// MARK: - ContactListViewModel

final class ContactListViewModel: ViewModel {
    // MARK: State

    @Published var searchString = ""
    @Published var users = [User]()
    @Published var error: Error?

    @Published var viewState = ViewState.loading

    @Published var isCreateConversationEnabled = false

    // MARK: Action

    let requestPermissionSubject = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    var isMultiSelectionEnabled: Bool
    private let contactService: ContactServiceType
    private let contactListUseCase: ContactListUseCase
    private let conversationService: ConversationServiceType
    private weak var delegate: ContactListViewModelDelegate?

    // MARK: Private

    private let loadDataSubject = PassthroughSubject<Void, Never>()

    private var allUsers = [User]()

    private var cancellables = Set<AnyCancellable>()

    init(isMultiSelectionEnabled: Bool,
         contactService: ContactServiceType = ContactService.default,
         contactListUseCase: ContactListUseCase,
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: ContactListViewModelDelegate? = nil) {
        self.isMultiSelectionEnabled = isMultiSelectionEnabled
        self.contactService = contactService
        self.contactListUseCase = contactListUseCase
        self.conversationService = conversationService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
    }

    private func configureLoadData() {
        loadDataSubject
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
                        return self.contactListUseCase.getContacts(page: 1, pageSize: 1000)
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
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
    }

    private func configureActions() {
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
}
