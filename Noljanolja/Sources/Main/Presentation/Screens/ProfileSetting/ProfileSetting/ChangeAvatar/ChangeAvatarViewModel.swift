//
//  ChangeAvatarViewModel.swift
//  Noljanolja
//
//  Created by duydinhv on 06/12/2023.
//

import _SwiftUINavigationState
import Combine
import Foundation
import UIKit

// MARK: - ChangeAvatarAlertActionType

enum ChangeAvatarAlertActionType: Equatable {
    case confirmChange(UIImage)
}

// MARK: - ChangeAvatarViewModelDelegate

protocol ChangeAvatarViewModelDelegate: AnyObject {
    func finishChangeAvatar()
}

// MARK: - ChangeAvatarViewModel

final class ChangeAvatarViewModel: ViewModel {
    @Published var photoAssets: [PhotoAsset] = []
    @Published var avatarImage: UIImage?
    @Published var isProgressHUDShowing = false
    @Published var viewState = ViewState.loading
    @Published var alertState: AlertState<ChangeAvatarAlertActionType>?

    private let userUseCases: UserUseCases

    var backAction = PassthroughSubject<Void, Never>()
    var doneAction = PassthroughSubject<Void, Never>()
    var confirmAction = PassthroughSubject<UIImage, Never>()

    private var delegate: ChangeAvatarViewModelDelegate?
    private var cancellables = Set<AnyCancellable>()

    init(userUseCases: UserUseCases = UserUseCasesImpl.default,
         delegate: ChangeAvatarViewModelDelegate) {
        self.userUseCases = userUseCases
        self.delegate = delegate
        super.init()
        configureAction()
    }

    private func configureAction() {
        $photoAssets
            .map { $0.first }
            .compactMap { $0 }
            .sink { [weak self] photoAsset in
                guard let self else { return }
                photoAsset.asset.requestThumbnail(
                    targetSize: .init(
                        width: UIScreen.mainWidth,
                        height: UIScreen.mainWidth
                    )) { [weak self] image in
                        self?.avatarImage = image
                    }
            }
            .store(in: &cancellables)

        doneAction
            .combineLatest($avatarImage)
            .compactMap { $0.1 }
            .sink { [weak self] image in
                guard let self else { return }
                self.alertState = AlertState(
                    title: TextState("Do you want to change avatar?"),
                    message: TextState("This picture will be set as your default avatar."),
                    primaryButton: .default(TextState(L10n.commonYes), action: .send(.confirmChange(image))),
                    secondaryButton: .cancel(TextState(L10n.commonNo))
                )
            }
            .store(in: &cancellables)

        confirmAction
            .compactMap { $0.jpegData(compressionQuality: 0.5) }
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
                    self.backAction.send()
                    self.delegate?.finishChangeAvatar()
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)
    }
}
