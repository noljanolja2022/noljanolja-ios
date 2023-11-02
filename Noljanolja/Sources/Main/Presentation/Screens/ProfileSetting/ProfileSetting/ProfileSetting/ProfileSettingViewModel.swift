//
//  ProfileSettingViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ProfileSettingViewModelDelegate

protocol ProfileSettingViewModelDelegate: AnyObject {
    func profileSettingViewModelSignOut()
}

// MARK: - ProfileSettingViewModel

final class ProfileSettingViewModel: ViewModel {
    // MARK: State

    @Published var name = ""
    @Published var phoneNumber = ""
    @Published var appVersion = ""

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<ProfileSettingAlertActionType>?

    // MARK: Navigations

    @Published var navigationType: SettingNavigationType?

    // MARK: Action

    let clearCacheConfirmAction = PassthroughSubject<Void, Never>()
    let clearCacheAction = PassthroughSubject<Void, Never>()
    let clearCacheResultAction = PassthroughSubject<Void, Never>()
    let signOutConfirmAction = PassthroughSubject<Void, Never>()
    let signOutAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let userUseCases: UserUseCases
    private let authUseCases: AuthUseCases
    private let deleteCacheUseCase: DeleteCacheUseCaseProtocol
    private weak var delegate: ProfileSettingViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    init(userUseCases: UserUseCases = UserUseCasesImpl.default,
         authUseCases: AuthUseCases = AuthUseCasesImpl.default,
         deleteCacheUseCase: DeleteCacheUseCaseProtocol = DeleteCacheUseCase.default,
         delegate: ProfileSettingViewModelDelegate? = nil) {
        self.userUseCases = userUseCases
        self.authUseCases = authUseCases
        self.deleteCacheUseCase = deleteCacheUseCase
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureActions()
        configureLoadData()
    }

    private func configureLoadData() {
        appVersion = {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            return appVersion ?? ""
        }()

        currentUserSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.name = user.name ?? ""
                self?.phoneNumber = user.phone
                    .flatMap {
                        $0.formatPhone()
                    }
                    .flatMap { string in
                        let maxLength = 4
                        if string.count > maxLength {
                            let hiddenString = Array(repeating: "*", count: string.count - maxLength).joined()
                            let shownString = string[string.index(string.endIndex, offsetBy: -4)...]
                            return hiddenString + shownString
                        } else {
                            return Array(repeating: "*", count: string.count).joined()
                        }
                    } ?? ""
            })
            .store(in: &cancellables)

        userUseCases.getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in
                self?.currentUserSubject.send($0)
            })
            .store(in: &cancellables)
    }

    private func configureActions() {
        Publishers.MergeMany(
            clearCacheConfirmAction
                .map {
                    AlertState(
                        title: TextState(L10n.settingWarningClearCacheTitle),
                        message: TextState(L10n.settingWarningClearCacheDescription),
                        primaryButton: .destructive(TextState(L10n.commonDisagree.uppercased())),
                        secondaryButton: .default(TextState(L10n.commonAgree.uppercased()), action: .send(.clearCache))
                    )
                },
            clearCacheResultAction
                .map {
                    AlertState(
                        title: TextState(L10n.commonSuccess),
                        message: TextState(L10n.settingClearCacheSuccessDescription),
                        dismissButton: .cancel(TextState(L10n.commonContinue.uppercased()))
                    )
                },
            signOutConfirmAction
                .map {
                    AlertState(
                        title: TextState(L10n.settingWarningLogOutTitle),
                        primaryButton: .destructive(TextState(L10n.commonNo)),
                        secondaryButton: .default(TextState(L10n.commonYes), action: .send(.clearCache))
                    )
                }
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] in
            self?.alertState = $0
        })
        .store(in: &cancellables)

        clearCacheAction
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let self else { return }
                self.deleteCacheUseCase.deleteCache()
                self.clearCacheResultAction.send()
            })
            .store(in: &cancellables)

        signOutAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                return self.authUseCases.signOut()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    self.delegate?.profileSettingViewModelSignOut()
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
}