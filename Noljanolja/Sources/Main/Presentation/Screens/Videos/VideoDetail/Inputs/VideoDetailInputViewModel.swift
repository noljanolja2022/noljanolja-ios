//
//  VideoDetailInputViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/04/2023.
//
//

import Combine
import Foundation

// MARK: - VideoDetailInputViewModelDelegate

protocol VideoDetailInputViewModelDelegate: AnyObject {
    func didCommentSuccess(_ comment: VideoComment)
}

// MARK: - VideoDetailInputViewModel

final class VideoDetailInputViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var user: User?

    // MARK: Action

    let sendCommentAction = PassthroughSubject<String, Never>()

    // MARK: Dependencies

    private let videoId: String
    private let userService: UserServiceType
    private let videoAPI: VideoAPIType
    private weak var delegate: VideoDetailInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(videoId: String,
         userService: UserServiceType = UserService.default,
         videoAPI: VideoAPIType = VideoAPI.default,
         delegate: VideoDetailInputViewModelDelegate? = nil) {
        self.videoId = videoId
        self.userService = userService
        self.videoAPI = videoAPI
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        userService
            .getCurrentUserPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)

        sendCommentAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] comment -> AnyPublisher<VideoComment, Error> in
                guard let self else {
                    return Empty<VideoComment, Error>().eraseToAnyPublisher()
                }
                return self.videoAPI
                    .postVideoComment(videoId: self.videoId, comment: comment)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(comment):
                    self.delegate?.didCommentSuccess(comment)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
