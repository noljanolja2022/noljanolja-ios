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
        var contactModels = [ContactModel]()
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

    private var allContactModels = [ContactModel]()
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
        $state
            .map(\.searchString)
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { [weak self] text in
                let allContactModels = self?.allContactModels ?? []
                return allContactModels
                    .filter {
                        guard !text.isEmpty else { return true }
                        return $0.name.lowercased().contains(text.lowercased())
                            || $0.phone.reduce(false) { $0 || $1.lowercased().contains(text.lowercased()) }
                    }
                    .sorted(by: \.name)
            }
            .sink(receiveValue: { [weak self] in self?.state.contactModels = $0 })
            .store(in: &cancellables)

        getContactsTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.state.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[ContactModel], Error> in
                guard let self else {
                    return Empty<[ContactModel], Error>().eraseToAnyPublisher()
                }
                return self.contactService.getContacts()
            }
            .sink(receiveValue: { result in
                switch result {
                case let .success(contactModels):
                    logger.info("Get contacts successful")
                    self.allContactModels = contactModels.sorted(by: \.name)
                    self.state.contactModels = contactModels.sorted(by: \.name)
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
