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
    func reactPromote(videoId: String) -> AnyPublisher<Void, Error>
    func postVideoComment(videoId: String, comment: String) -> AnyPublisher<VideoComment, Error>
}

// MARK: - VideoUseCasesImpl

final class VideoUseCasesImpl: VideoUseCases {
    static let shared = VideoUseCasesImpl()

    private let videoNetworkRepository: VideoNetworkRepository

    init(videoNetworkRepository: VideoNetworkRepository = VideoNetworkRepositoryImpl.shared) {
        self.videoNetworkRepository = videoNetworkRepository
    }

    func reactPromote(videoId: String) -> AnyPublisher<Void, Error> {
        let reactPromote = { [weak self] in
            guard let self else {
                return Fail<Void, Error>(error: CommonError.captureSelfNotFound)
                    .eraseToAnyPublisher()
            }
            guard let accessTokenString = GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString else {
                return Fail<Void, Error>(error: CommonError.informationNotFound(message: "Access token not found"))
                    .eraseToAnyPublisher()
            }
            return self.videoNetworkRepository.reactPromote(videoId: videoId, youtubeToken: accessTokenString)
        }

        return GIDSignIn.sharedInstance.signInIfNeededCombine(additionalScopes: [GIDSignInScope.youtube])
            .flatMapLatest { _ in
                reactPromote()
            }
            .eraseToAnyPublisher()
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
            return self.videoNetworkRepository.postVideoComment(videoId: videoId, comment: comment, youtubeToken: accessTokenString)
        }

        return GIDSignIn.sharedInstance.signInIfNeededCombine(additionalScopes: [GIDSignInScope.youtube])
            .flatMap { _ in
                postComment()
            }
            .eraseToAnyPublisher()
    }
}
