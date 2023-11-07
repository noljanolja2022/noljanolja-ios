//
//  ContactListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//
//

import Combine
import Foundation
import SwiftUI

// MARK: - ContactListViewModelDelegate

protocol ContactListViewModelDelegate: AnyObject {}

// MARK: - ContactListViewModel

final class ContactListViewModel: ViewModel {
    // MARK: State

    @Published var searchString = ""
    @Published var users = [User]()
    @Published var error: Error?

    @Published var viewState = ViewState.loading

    // MARK: Action

    let requestPermissionSubject = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    var isMultiSelectionEnabled: Bool
    var isSearchHidden: Bool
    var axis: Axis
    private let contactUseCases: ContactUseCases
    private let contactListUseCases: ContactListUseCases
    private weak var delegate: ContactListViewModelDelegate?

    // MARK: Private

    private let loadDataSubject = PassthroughSubject<Void, Never>()

    private var allUsers = [User]()

    private var cancellables = Set<AnyCancellable>()

    init(isMultiSelectionEnabled: Bool,
         isSearchHidden: Bool = false,
         axis: Axis = .vertical,
         contactUseCases: ContactUseCases = ContactUseCasesImpl.default,
         contactListUseCases: ContactListUseCases,
         delegate: ContactListViewModelDelegate? = nil) {
        self.isMultiSelectionEnabled = isMultiSelectionEnabled
        self.isSearchHidden = isSearchHidden
        self.axis = axis
        self.contactUseCases = contactUseCases
        self.contactListUseCases = contactListUseCases
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
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .receive(on: DispatchQueue.global())
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.contactListUseCases.getContacts(page: 1, pageSize: 1000)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { result in
                switch result {
                case let .success(users):
                    self.allUsers = users
                    self.users = users
                    self.viewState = .content
                case let .failure(error):
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
                return self.contactUseCases.requestContactPermission()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.loadDataSubject.send()
                case let .failure(error):
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
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.users = $0 })
            .store(in: &cancellables)
    }
}
