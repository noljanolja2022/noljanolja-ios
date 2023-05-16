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
    func settingViewModelSignOut()
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

    private let userService: UserServiceType
    private let authService: AuthServiceType
    private let deleteCacheUseCase: DeleteCacheUseCaseProtocol
    private weak var delegate: ProfileSettingViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    init(userService: UserServiceType = UserService.default,
         authService: AuthServiceType = AuthService.default,
         deleteCacheUseCase: DeleteCacheUseCaseProtocol = DeleteCacheUseCase.default,
         delegate: ProfileSettingViewModelDelegate? = nil) {
        self.userService = userService
        self.authService = authService
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

        userService.getCurrentUserPublisher()
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
                        title: TextState("Are you sure to clear cache data?"),
                        message: TextState("All your cache will be deleted after you do this action."),
                        primaryButton: .destructive(TextState("DISGREE")),
                        secondaryButton: .default(TextState("AGREE"), action: .send(.clearCache))
                    )
                },
            clearCacheResultAction
                .map {
                    AlertState(
                        title: TextState("Success!"),
                        message: TextState("Clear cache data completed."),
                        dismissButton: .cancel(TextState("continue"))
                    )
                },
            signOutConfirmAction
                .map {
                    AlertState(
                        title: TextState("Do you want to Log out"),
                        primaryButton: .destructive(TextState("No")),
                        secondaryButton: .default(TextState("Yes"), action: .send(.clearCache))
                    )
                }
        )
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
            .handleEvents(receiveOutput: { [weak self] in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                return self.authService.signOut()
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    self.delegate?.settingViewModelSignOut()
                case .failure:
                    self.alertState = AlertState(
                        title: TextState("Error"),
                        message: TextState(L10n.Common.Error.message),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }
}
