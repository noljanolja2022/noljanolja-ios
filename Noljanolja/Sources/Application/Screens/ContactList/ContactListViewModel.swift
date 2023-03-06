//
//  ContactListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import Foundation

// MARK: - ContactListViewModelDelegate

protocol ContactListViewModelDelegate: AnyObject {}

// MARK: - ContactListViewModelType

protocol ContactListViewModelType:
    ViewModelType where State == ContactListViewModel.State, Action == ContactListViewModel.Action {}

extension ContactListViewModel {
    struct State {
        var contactModels = [ContactModel]()
        var error: Error?
        var viewState = ViewState.content
    }

    enum Action {
        case loadData
    }
}

// MARK: - ContactListViewModel

final class ContactListViewModel: ContactListViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let contactService: ContactServiceType
    private weak var delegate: ContactListViewModelDelegate?

    // MARK: Action

    private let getContactsTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         contactService: ContactServiceType = ContactService.default,
         delegate: ContactListViewModelDelegate? = nil) {
        self.state = state
        self.contactService = contactService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            getContactsTrigger.send()
        }
    }

    private func configure() {
        getContactsTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.state.viewState = .loading })
            .flatMap { [weak self] _ -> AnyPublisher<[ContactModel], Error> in
                guard let self else {
                    return Empty<[ContactModel], Error>().eraseToAnyPublisher()
                }
                return self.contactService.getContacts()
            }
            .eraseToResultAnyPublisher()
            .sink(receiveValue: { result in
                switch result {
                case let .success(contactModels):
                    logger.info("Get contacts successful")
                    self.state.contactModels = contactModels
                    self.state.viewState = .content
                case let .failure(error):
                    logger.error("Get contacts failed: \(error.localizedDescription)")
                    self.state.error = error
                    self.state.viewState = .error
                }
            })
            .store(in: &cancellables)
    }
}
