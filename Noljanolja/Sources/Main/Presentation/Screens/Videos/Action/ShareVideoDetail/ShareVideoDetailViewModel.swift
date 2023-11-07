//
//  ShareVideoDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 29/07/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ShareVideoDetailViewModelDelegate

protocol ShareVideoDetailViewModelDelegate: AnyObject {
    func shareVideoDetailViewModelDidShare()
}

// MARK: - ShareVideoDetailViewModel

final class ShareVideoDetailViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Action

    let action = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let video: Video
    let user: User
    private let messageUseCases: MessageUseCases
    private weak var delegate: ShareVideoDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(video: Video,
         user: User,
         messageUseCases: MessageUseCases = MessageUseCasesImpl.default,
         delegate: ShareVideoDetailViewModelDelegate? = nil) {
        self.video = video
        self.user = user
        self.messageUseCases = messageUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        action
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isProgressHUDShowing = true
            })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[Message], Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.messageUseCases
                    .shareMessage(
                        request: ShareMessageRequest(type: .plaintext, shareVideo: video),
                        users: [user]
                    )
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    self.delegate?.shareVideoDetailViewModelDidShare()
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
