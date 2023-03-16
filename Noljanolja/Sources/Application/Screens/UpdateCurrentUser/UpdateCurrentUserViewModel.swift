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
    func didUpdateCurrentUser()
}

// MARK: - UpdateCurrentUserViewModelType

protocol UpdateCurrentUserViewModelType:
    ViewModelType where State == UpdateCurrentUserViewModel.State, Action == UpdateCurrentUserViewModel.Action {}

extension UpdateCurrentUserViewModel {
    struct State {
        enum ActionSheetType: Int, Identifiable {
            case avatar
            case gender

            var id: Int { rawValue }
        }

        var image: UIImage?
        var avatar: String?
        var name: String?
        var dob: Date?
        var gender: GenderType?

        var actionSheetType: ActionSheetType?

        var isProgressHUDShowing = false
        var alertState: AlertState<Void>?
    }

    enum Action {
        case openAvatarActionSheet
        case openGenderActionSheet
        case updateCurrentUser
    }
}

// MARK: - UpdateCurrentUserViewModel

final class UpdateCurrentUserViewModel: UpdateCurrentUserViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let userService: UserServiceType
    private weak var delegate: UpdateCurrentUserViewModelDelegate?

    // MARK: Action

    private let validateUpdateCurrentUserTrigger = PassthroughSubject<Void, Never>()
    private let updateCurrentUserTrigger = PassthroughSubject<UpdateCurrentUserParam, Never>()

    // MARK: Data

    private let currentUserSubject = PassthroughSubject<User, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         userService: UserServiceType = UserService.default,
         delegate: UpdateCurrentUserViewModelDelegate? = nil) {
        self.state = state
        self.userService = userService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .openAvatarActionSheet:
            state.actionSheetType = .avatar
        case .openGenderActionSheet:
            state.actionSheetType = .gender
        case .updateCurrentUser:
            validateUpdateCurrentUserTrigger.send()
        }
    }

    private func configure() {
        currentUserSubject
            .sink(receiveValue: { [weak self] user in
                self?.state.avatar = user.avatar
                self?.state.name = user.name
                self?.state.dob = user.dob
                self?.state.gender = user.gender
            })
            .store(in: &cancellables)

        validateUpdateCurrentUserTrigger
            .withLatestFrom(currentUserSubject)
            .sink(receiveValue: { [weak self] _ in
                guard let name = self?.state.name, !name.isEmpty else {
                    self?.state.alertState = AlertState(
                        title: TextState("Error"),
                        message: TextState("Please enter all fields"),
                        dismissButton: .cancel(TextState("OK"))
                    )
                    return
                }

                let param = UpdateCurrentUserParam(
                    name: name.trimmed,
                    gender: self?.state.gender,
                    dob: self?.state.dob
                )
                self?.updateCurrentUserTrigger.send(param)
            })
            .store(in: &cancellables)

        updateCurrentUserTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.state.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] param in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                return self.userService.updateCurrentUser(param)
            }
            .sink(receiveValue: { [weak self] _ in
                self?.state.isProgressHUDShowing = false
                self?.delegate?.didUpdateCurrentUser()
            })
            .store(in: &cancellables)

        userService
            .currentUserPublisher
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)
    }
}
