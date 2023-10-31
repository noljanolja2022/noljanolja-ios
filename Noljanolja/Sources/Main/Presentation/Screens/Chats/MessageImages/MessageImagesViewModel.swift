//
//  MessageImagesViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/07/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import UIKit

// MARK: - MessageImagesViewModelDelegate

protocol MessageImagesViewModelDelegate: AnyObject {
    func messageImagesViewModel(sendImage image: UIImage)
}

// MARK: - MessageImagesViewModel

final class MessageImagesViewModel: ViewModel {
    // MARK: State
    
    @Published var viewState = ViewState.content
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var title = ""
    @Published var models = [PhotoMessageContentItemModel]()
    
    // MARK: Navigations

    @Published var fullScreenCoverType: MessageImagesFullScreenCoverType?
    
    // MARK: Action

    // MARK: Dependencies

    private let messageSubject: CurrentValueSubject<Message, Never>
    private let userUseCases: UserUseCases
    private weak var delegate: MessageImagesViewModelDelegate?

    // MARK: Private

    private let userSubject = PassthroughSubject<User, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(message: Message,
         userUseCases: UserUseCases = UserUseCasesImpl.default,
         delegate: MessageImagesViewModelDelegate? = nil) {
        self.messageSubject = CurrentValueSubject<Message, Never>(message)
        self.userUseCases = userUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureLoadData()
    }
    
    private func configureBindData() {
        Publishers.CombineLatest(messageSubject, userSubject)
            .map { message, _ in
                message.attachments
                    .map { attachment in
                        PhotoMessageContentItemModel(
                            url: attachment.getPhotoURL(conversationID: message.conversationID),
                            createdAt: message.createdAt,
                            status: MessageStatusModel.StatusType.none
                        )
                    }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.models = $0
                self.title = "\(models.count) Files"
            }
            .store(in: &cancellables)
    }
    
    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<User, Error> in
                guard let self else {
                    return Fail(error: CommonError.unknown).eraseToAnyPublisher()
                }
                return self.userUseCases.getCurrentUserIfNeeded()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.userSubject.send(model)
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: ImageDetailViewModelDelegate

extension MessageImagesViewModel: ImageDetailViewModelDelegate {
    func imageDetailViewModel(sendImage image: UIImage) {
        delegate?.messageImagesViewModel(sendImage: image)
    }
}
