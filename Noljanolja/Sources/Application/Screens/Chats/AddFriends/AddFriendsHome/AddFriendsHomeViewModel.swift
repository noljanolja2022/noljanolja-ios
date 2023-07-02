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

    @Published var country = CountryAPI().getDefaultCountry()
    @Published var phoneNumberText = ""
    @Published var name: String?
    @Published var qrImage: UIImage?
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    var phoneNumber: String? {
        "\(country.prefix)\(phoneNumberText)"
    }

    // MARK: Navigations

    @Published var navigationType: AddFriendsNavigationType?
    @Published var fullScreenCoverType: AddFriendsScreenCoverType?

    // MARK: Action

    let searchAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let userService: UserServiceType
    private let userAPI: UserAPIType
    private weak var delegate: AddFriendsHomeViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = PassthroughSubject<User, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(userService: UserServiceType = UserService.default,
         userAPI: UserAPIType = UserAPI.default,
         delegate: AddFriendsHomeViewModelDelegate? = nil) {
        self.userService = userService
        self.userAPI = userAPI
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
    }

    private func configureActions() {
        searchAction
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isProgressHUDShowing = true
            })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.userAPI.findUsers(phoneNumber: self.phoneNumber?.formatPhone(), friendId: nil)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    if model.isEmpty {
                        self.alertState = AlertState(
                            title: TextState(L10n.commonErrorTitle),
                            message: TextState(L10n.addFriendPhoneNotAvailable),
                            dismissButton: .cancel(TextState(L10n.commonClose))
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
        userService.getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in
                self?.currentUserSubject.send($0)
            })
            .store(in: &cancellables)
    }
}

// MARK: SelectCountryViewModelDelegate

extension AddFriendsHomeViewModel: SelectCountryViewModelDelegate {
    func didSelectCountry(_ country: Country) {
        self.country = country
    }
}