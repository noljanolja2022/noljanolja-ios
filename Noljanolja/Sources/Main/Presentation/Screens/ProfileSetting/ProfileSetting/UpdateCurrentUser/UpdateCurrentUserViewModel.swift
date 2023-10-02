//
//  UpdateCurrentUserViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/03/2023.
//
//

import Combine
import Foundation
import SwiftUINavigation
import UIKit

// MARK: - UpdateCurrentUserViewModelDelegate

protocol UpdateCurrentUserViewModelDelegate: AnyObject {
    func updateCurrentUserViewModelDidComplete()
}

// MARK: - UpdateCurrentUserViewModel

final class UpdateCurrentUserViewModel: ViewModel {
    // MARK: State

    @Published var image: UIImage?
    @Published var avatar: String?
    @Published var name: String?
    @Published var country = CountryAPI().getDefaultCountry()
    @Published var phoneNumberText = ""
    @Published var dob: Date?
    @Published var gender: GenderType?

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Navigation

    @Published var actionSheetType: UpdateCurrentUserActionSheetType?
    @Published var fullScreenCoverType: UpdateCurrentUserFullScreenCoverType?

    // MARK: Action

    let validateUpdateCurrentUserAction = PassthroughSubject<Void, Never>()
    let updateCurrentUserAction = PassthroughSubject<UpdateCurrentUserParam, Never>()

    // MARK: Dependencies

    private let userService: UserServiceType
    private weak var delegate: UpdateCurrentUserViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = PassthroughSubject<User, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(userService: UserServiceType = UserService.default,
         delegate: UpdateCurrentUserViewModelDelegate? = nil) {
        self.userService = userService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        currentUserSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.avatar = user.avatar
                self?.name = user.name
                self?.dob = user.dob
                self?.gender = user.gender
            })
            .store(in: &cancellables)

        $image
            .compactMap { $0?.jpegData(compressionQuality: 0.5) }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] imageData in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                return self.userService.updateCurrentUserAvatar(imageData)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    return
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        validateUpdateCurrentUserAction
            .withLatestFrom(currentUserSubject)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                if let name, !name.isEmpty,
                   !phoneNumberText.isEmpty {
                    let param = UpdateCurrentUserParam(
                        name: name.trimmed,
                        phone: phoneNumberText,
                        gender: gender,
                        dob: dob
                    )
                    updateCurrentUserAction.send(param)
                } else {
                    alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState("Please enter all fields"),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        updateCurrentUserAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] param in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                return self.userService.updateCurrentUser(param)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    self.delegate?.updateCurrentUserViewModelDidComplete()
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        userService
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)
    }
}

// MARK: SelectCountryViewModelDelegate

extension UpdateCurrentUserViewModel: SelectCountryViewModelDelegate {
    func selectCountryViewModel(didSelectCountry country: Country) {
        self.country = country
    }
}
