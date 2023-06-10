//
//  AddFriendsViewModel.swift
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

// MARK: - AddFriendsViewModelDelegate

protocol AddFriendsViewModelDelegate: AnyObject {}

// MARK: - AddFriendsViewModel

final class AddFriendsViewModel: ViewModel {
    // MARK: State

    @Published var country = CountryAPI().getDefaultCountry()
    @Published var phoneNumberText = ""
    @Published var name: String?
    @Published var qrImage: UIImage?
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    var phoneNumber: String? {
        "+\(country.phoneCode)\(phoneNumberText)"
    }

    // MARK: Navigations

    @Published var navigationType: AddFriendsNavigationType?
    @Published var fullScreenCoverType: AddFriendsScreenCoverType?

    // MARK: Action

    let searchAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let userService: UserServiceType
    private weak var delegate: AddFriendsViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = PassthroughSubject<User, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(userService: UserServiceType = UserService.default,
         delegate: AddFriendsViewModelDelegate? = nil) {
        self.userService = userService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
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
                let filter = CIFilter.qrCodeGenerator()
                let string = "nolljanollja:id:\(user.id)"
                guard let data = string.data(using: .utf8) else { return nil }
                filter.message = data
                guard let outputImage = filter.outputImage,
                      let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
                    return nil
                }
                return UIImage(cgImage: cgImage)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.qrImage = $0
            })
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

extension AddFriendsViewModel: SelectCountryViewModelDelegate {
    func didSelectCountry(_ country: Country) {
        self.country = country
    }
}

// MARK: FindUsersViewModelDelegate

extension AddFriendsViewModel: FindUsersViewModelDelegate {
    func findUsersViewModel(didFind users: [User]) {
        navigationType = .result(users)
    }
}
