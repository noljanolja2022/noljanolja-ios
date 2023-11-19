//
//  AddFriendsHomeViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import CoreImage.CIFilterBuiltins
import Foundation
import UIKit

// MARK: - AddFriendsHomeViewModelDelegate

protocol AddFriendsHomeViewModelDelegate: AnyObject {}

// MARK: - AddFriendsHomeViewModel

final class AddFriendsHomeViewModel: ViewModel {
    // MARK: State

    @Published var country = CountryNetworkRepositoryImpl().getDefaultCountry()
    @Published var phoneNumberText = ""
    @Published var name: String?
    @Published var qrImage: UIImage?
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var isDisableSearch = false
    
    var phoneNumber: String? {
        "\(country.prefix)\(phoneNumberText)"
    }

    // MARK: Navigations

    @Published var navigationType: AddFriendsNavigationType?
    @Published var fullScreenCoverType: AddFriendsScreenCoverType?

    // MARK: Action

    let searchAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let userUseCases: UserUseCases
    private let userNetworkRepository: UserNetworkRepository
    private weak var delegate: AddFriendsHomeViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = PassthroughSubject<User, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(userUseCases: UserUseCases = UserUseCasesImpl.default,
         userNetworkRepository: UserNetworkRepository = UserNetworkRepositoryImpl.default,
         delegate: AddFriendsHomeViewModelDelegate? = nil) {
        self.userUseCases = userUseCases
        self.userNetworkRepository = userNetworkRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureActions()
        configureLoadData()
    }

    private func configureBindData() {
        currentUserSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.name = user.name
            }
            .store(in: &cancellables)

        currentUserSubject
            .receive(on: DispatchQueue.global(qos: .background))
            .compactMap { user -> UIImage? in
                "nolljanollja:id:\(user.id)".qrCodeImage()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.qrImage = $0
            })
            .store(in: &cancellables)
        
        $phoneNumberText
            .map { $0.isEmpty }
            .assign(to: &$isDisableSearch)
    }

    private func configureActions() {
        searchAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isProgressHUDShowing = true
            })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.userNetworkRepository.findUsers(phoneNumber: self.phoneNumber?.formatPhone(), friendId: nil)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    if model.isEmpty {
                        self.alertState = AlertState(
                            title: TextState(L10n.commonSorry),
                            message: TextState(L10n.errorPhoneIsNotAvailable),
                            dismissButton: .cancel(TextState(L10n.commonCancel))
                        )
                    } else {
                        self.navigationType = .result(model)
                    }
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }

    private func configureLoadData() {
        userUseCases.getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in
                self?.currentUserSubject.send($0)
            })
            .store(in: &cancellables)
    }
}

// MARK: SelectCountryViewModelDelegate

extension AddFriendsHomeViewModel: SelectCountryViewModelDelegate {
    func selectCountryViewModel(didSelectCountry country: Country) {
        self.country = country
    }
}
