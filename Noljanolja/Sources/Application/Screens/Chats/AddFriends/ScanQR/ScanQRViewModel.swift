//
//  ScanQRViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import UIKit

// MARK: - ScanQRViewModelDelegate

protocol ScanQRViewModelDelegate: AnyObject {}

// MARK: - ScanQRViewModel

final class ScanQRViewModel: ViewModel {
    // MARK: State

    @Published var image: UIImage?
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Navigations

    @Published var navigationType: ScanQRNavigationType?
    @Published var fullScreenCoverType: ScanQRFullScreenCoverType?

    // MARK: Action

    private let findUserAction = PassthroughSubject<String, Never>()

    // MARK: Dependencies

    private weak var delegate: ScanQRViewModelDelegate?

    // MARK: Private

    private let userAPI: UserAPIType
    private var cancellables = Set<AnyCancellable>()

    init(userAPI: UserAPIType = UserAPI.default,
         delegate: ScanQRViewModelDelegate? = nil) {
        self.userAPI = userAPI
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        $image
            .receive(on: DispatchQueue.global(qos: .background))
            .compactMap { $0?.detectQRCode().first }
            .compactMap {
                let components = $0.split(separator: ":")
                if components.count == 3,
                   components.first == "nolljanollja",
                   let userId = components.last {
                    return String(userId)
                } else {
                    return nil
                }
            }
            .sink(receiveValue: { [weak self] in
                self?.findUserAction.send($0)
            })
            .store(in: &cancellables)

        configureActions()
    }

    private func configureActions() {
        findUserAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isProgressHUDShowing = true
            })
            .flatMapLatestToResult { [weak self] userId in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.userAPI.findUsers(phoneNumber: nil, friendId: userId)
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
}
