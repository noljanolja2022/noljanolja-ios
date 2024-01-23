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
import SDWebImageSwiftUI
import UIKit

// MARK: - ProfileSettingViewModelDelegate

protocol ProfileSettingViewModelDelegate: AnyObject {
    func profileSettingViewModelSignOut()
}

// MARK: - ProfileSettingViewModel

final class ProfileSettingViewModel: ViewModel {
    // MARK: State

    @Published var name = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var gender: GenderType?
    @Published var appVersion = ""
    @Published var avatarURL: String?
    @Published var image: UIImage?
    @Published var ranking: LoyaltyTierModelType?
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<ProfileSettingAlertActionType>?
    @Published var viewState = ViewState.loading
    @Published var isShowFinishAvatar = false
    @Published var isNotification: Bool = UserDefaults.standard.isNotification

    // MARK: Navigations

    @Published var navigationType: SettingNavigationType?
    @Published var fullScreenCoverType: SettingFullScreenCoverType?

    // MARK: Action

    let clearCacheConfirmAction = PassthroughSubject<Void, Never>()
    let clearCacheAction = PassthroughSubject<Void, Never>()
    let clearCacheResultAction = PassthroughSubject<Void, Never>()
    let signOutConfirmAction = PassthroughSubject<Void, Never>()
    let signOutAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let userUseCases: UserUseCases
    private let authUseCases: AuthUseCases
    private let memberInfoUseCase: MemberInfoUseCases
    private let deleteCacheUseCase: DeleteCacheUseCaseProtocol
    private weak var delegate: ProfileSettingViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    init(userUseCases: UserUseCases = UserUseCasesImpl.default,
         authUseCases: AuthUseCases = AuthUseCasesImpl.default,
         memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         deleteCacheUseCase: DeleteCacheUseCaseProtocol = DeleteCacheUseCase.default,
         delegate: ProfileSettingViewModelDelegate? = nil) {
        self.userUseCases = userUseCases
        self.authUseCases = authUseCases
        self.memberInfoUseCase = memberInfoUseCase
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
                self?.gender = user.gender
                self?.avatarURL = user.avatar
                self?.name = user.name ?? ""
                self?.email = user.email ?? ""
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

        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<LoyaltyMemberInfo, Error> in
                guard let self else {
                    return Empty<LoyaltyMemberInfo, Error>().eraseToAnyPublisher()
                }
                return self.memberInfoUseCase.getLoyaltyMemberInfo()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.memberInfoSubject.send(model)
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)

        memberInfoSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.ranking = .init(tier: $0.currentTier)
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
                return self.userUseCases.updateCurrentUserAvatar(imageData)
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

        $isNotification
            .sink { value in
                UserDefaults.standard.isNotification = value
                if value {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    UIApplication.shared.unregisterForRemoteNotifications()
                }
            }
            .store(in: &cancellables)
    }

    private func configureActions() {
        Publishers.MergeMany(
            clearCacheConfirmAction
                .map {
                    AlertState(
                        title: TextState(L10n.settingWarningClearCacheTitle),
                        message: TextState(L10n.settingWarningClearCacheDescription),
                        primaryButton: .destructive(TextState(L10n.commonNo.uppercased())),
                        secondaryButton: .default(
                            TextState(L10n.commonYes.uppercased()),
                            action: .send(.clearCache)
                        )
                    )
                },
//            clearCacheResultAction
//                .map {
//                    AlertState(
//                        title: TextState(L10n.commonSuccess),
//                        message: TextState(L10n.settingClearCacheSuccessDescription),
//                        dismissButton: .cancel(TextState(L10n.commonContinue.uppercased()))
//                    )
//                },
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

// MARK: ProfileActionViewModelDelegate

extension ProfileSettingViewModel: ProfileActionViewModelDelegate {
    func profileActionViewModel(didSelectItem item: ProfileActionItemViewModel) {
        switch item {
        case .openCamera:
            fullScreenCoverType = .imagePickerView(.camera)
        case .selectFromAlbum:
            navigationType = .changeAvatarAlbum
        }
    }
}

// MARK: ChangeAvatarViewModelDelegate

extension ProfileSettingViewModel: ChangeAvatarViewModelDelegate {
    func finishChangeAvatar() {
        isShowFinishAvatar = true
    }
}
