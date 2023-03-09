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

protocol ContactListViewModelDelegate: AnyObject {}

// MARK: - ContactListViewModelType

protocol ContactListViewModelType:
    ViewModelType where State == ContactListViewModel.State, Action == ContactListViewModel.Action {}

extension ContactListViewModel {
    struct State {
        var searchString = ""
        var users = [User]()
        var error: Error?
        var viewState = ViewState.content
    }

    enum Action {
        case loadData
        case requestContactsPermission
        case openAppSetting
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
    private let requestContactsPermissionTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var allUsers = [User]()
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
        case .requestContactsPermission:
            requestContactsPermissionTrigger.send()
        case .openAppSetting:
            guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func configure() {
//        $state
//            .map(\.searchString)
//            .removeDuplicates()
//            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
//            .map { [weak self] text in
//                let allUsers = self?.allUsers ?? []
//                return allUsers
//                    .filter {
//                        guard !text.isEmpty else { return true }
//                        return $0.name.lowercased().contains(text.lowercased())
//                            || $0.phones.reduce(false) { $0 || $1.lowercased().contains(text.lowercased()) }
//                    }
//                    .sorted(by: \.name)
//            }
//            .sink(receiveValue: { [weak self] in self?.state.contacts = $0 })
//            .store(in: &cancellables)

        getContactsTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.state.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.contactService.getAuthorizationStatus()
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
                    self?.getContactsTrigger.send()
                case .failure:
                    break
                }
            })
            .store(in: &cancellables)
    }
}
