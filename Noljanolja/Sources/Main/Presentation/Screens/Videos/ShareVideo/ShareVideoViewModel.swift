//
//  ShareVideoViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ShareVideoViewModelDelegate

protocol ShareVideoViewModelDelegate: AnyObject {
    func didShare()
}

// MARK: - ShareVideoViewModel

final class ShareVideoViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Action

    let action = PassthroughSubject<User, Never>()

    // MARK: Dependencies

    private let video: Video
    private let messageService: MessageServiceType
    private weak var delegate: ShareVideoViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(video: Video,
         messageService: MessageServiceType = MessageService.default,
         delegate: ShareVideoViewModelDelegate? = nil) {
        self.video = video
        self.messageService = messageService
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
            .flatMapLatestToResult { [weak self] user -> AnyPublisher<[Message], Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.messageService
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
                    self.delegate?.didShare()
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
