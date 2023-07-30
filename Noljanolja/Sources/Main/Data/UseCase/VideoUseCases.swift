//
//  VideoUseCases.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/07/2023.
//

import Combine
import Foundation
import GoogleSignIn

// MARK: - VideoUseCases

protocol VideoUseCases {
    func postVideoComment(videoId: String, comment: String) -> AnyPublisher<VideoComment, Error>
}

// MARK: - VideoUseCasesImpl

final class VideoUseCasesImpl: VideoUseCases {
    static let shared = VideoUseCasesImpl()

    private let videoRepository: VideoRepository

    init(videoRepository: VideoRepository = VideoRepositoryImpl.shared) {
        self.videoRepository = videoRepository
    }

    func postVideoComment(videoId: String, comment: String) -> AnyPublisher<VideoComment, Error> {
        let postComment = { [weak self] in
            guard let self else {
                return Fail<VideoComment, Error>(error: CommonError.captureSelfNotFound)
                    .eraseToAnyPublisher()
            }
            guard let accessTokenString = GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString else {
                return Fail<VideoComment, Error>(error: CommonError.informationNotFound(message: "Access token not found"))
                    .eraseToAnyPublisher()
            }
            return self.videoRepository.postVideoComment(videoId: videoId, comment: comment, youtubeToken: accessTokenString)
        }

        return GIDSignIn.sharedInstance.signInIfNeededCombine(additionalScopes: [GIDSignInScope.youtube])
            .flatMap { _ in
                postComment()
            }
            .eraseToAnyPublisher()
    }
}
