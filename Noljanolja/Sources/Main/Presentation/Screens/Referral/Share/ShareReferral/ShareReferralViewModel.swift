//
//  ShareReferral.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/08/2023.
//

import _SwiftUINavigationState
import Combine
import Foundation
import SwiftUIX

// MARK: - ShareReferralViewModelDelegate

protocol ShareReferralViewModelDelegate: AnyObject {
    func shareReferralViewModelDidShare(conversationId: Int?)
}

// MARK: - ShareReferralViewModel

class ShareReferralViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Dependencies

    private let code: String?
    private var referralPoints: Int?
    private let messageUseCases: MessageUseCases
    private let rewardReferralUseCases: RewardReferralUseCases
    private weak var delegate: ShareReferralViewModelDelegate?

    // MARK: Action

    let action = PassthroughSubject<[User], Never>()
    let closeAction = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(code: String?,
         messageUseCases: MessageUseCases = MessageUseCasesImpl.default,
         rewardReferralUseCases: RewardReferralUseCases = RewardReferralUseCasesImpl.shared,
         delegate: ShareReferralViewModelDelegate? = nil) {
        self.code = code
        self.messageUseCases = messageUseCases
        self.rewardReferralUseCases = rewardReferralUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
    }

    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<ReferralPointsConfig, Error> in
                guard let self else {
                    return Empty<ReferralPointsConfig, Error>().eraseToAnyPublisher()
                }
                return self.rewardReferralUseCases.getReferralPoints()
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(data):
                    self.referralPoints = data.refererPoints
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func configureActions() {
        action
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] users -> AnyPublisher<[Message], Error> in
                guard let self, let referralPoints else {
                    return Fail<[Message], Error>(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.messageUseCases
                    .shareMessage(
                        request: ShareMessageRequest(
                            type: .plaintext,
                            message: "www.nolgubulgu.com\nJoin now to get\nUp to \(referralPoints) points!!!"
                        ),
                        users: users
                    )
                    .flatMap { [weak self] _ in
                        guard let self else {
                            return Fail<[Message], Error>(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                        }
                        return self.messageUseCases
                            .shareMessage(
                                request: ShareMessageRequest(
                                    type: .plaintext,
                                    message: self.code
                                ),
                                users: users
                            )
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] result in
                switch result {
                case let .success(messages):
                    self?.isProgressHUDShowing = false
                    self?.delegate?.shareReferralViewModelDidShare(conversationId: messages.first?.conversationID)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
