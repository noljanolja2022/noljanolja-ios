//
//  ChangeUsernameViewModel.swift
//  Noljanolja
//
//  Created by duydinhv on 18/01/2024.
//

import Combine
import Foundation
import SwiftUINavigation
import UIKit

final class ChangeUsernameViewModel: ViewModel {
    var phoneNumber = ""
    @Published var name = ""

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    let changeUsernameSucces = PassthroughSubject<Void, Never>()
    let updateCurrentUserAction = PassthroughSubject<Void, Never>()

    private let userUseCases: UserUseCases
    private let currentUserSubject = PassthroughSubject<User, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(userUseCases: UserUseCases = UserUseCasesImpl.default) {
        self.userUseCases = userUseCases
        super.init()

        configure()
    }

    func configure() {
        currentUserSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                guard let self else { return }
                self.phoneNumber = user.phone ?? ""
                self.name = user.name ?? ""
            })
            .store(in: &cancellables)

        updateCurrentUserAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                let param = UpdateCurrentUserParam(name: name, phone: phoneNumber)
                return self.userUseCases.updateCurrentUser(param)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    changeUsernameSucces.send()
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        userUseCases
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in
                print($0)
                self?.currentUserSubject.send($0)
            })
            .store(in: &cancellables)
    }
}
