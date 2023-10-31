//
//  MessageReactionUseCases.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/06/2023.
//

import Combine
import Foundation

// MARK: - ReactionIconsUseCasesProtocol

protocol ReactionIconsUseCasesProtocol {
    func getReactionIcons() -> AnyPublisher<[ReactIcon], Error>
}

// MARK: - ReactionIconsUseCases

final class ReactionIconsUseCases: ReactionIconsUseCasesProtocol {
    static let `default` = ReactionIconsUseCases()

    private let reactionIconsRemoteRepository: ReactionIconsRemoteRepositoryProtocol
    private let reactionIconsLocalRepository: ReactionIconsLocalRepository

    init(reactionIconsRemoteRepository: ReactionIconsRemoteRepositoryProtocol = ReactionIconsRemoteRepository.default,
         reactionIconsLocalRepository: ReactionIconsLocalRepository = ReactionIconsLocalRepositoryImpl.default) {
        self.reactionIconsRemoteRepository = reactionIconsRemoteRepository
        self.reactionIconsLocalRepository = reactionIconsLocalRepository
    }

    func getReactionIcons() -> AnyPublisher<[ReactIcon], Error> {
        let local = reactionIconsLocalRepository
            .observeReactIcons()
        let remote = reactionIconsRemoteRepository
            .getReactIcons()
            .handleEvents(receiveOutput: { [weak self] in
                self?.reactionIconsLocalRepository.saveReactIcons($0)
            })
        return local
            .flatMap { reactionIcons in
                if reactionIcons.isEmpty {
                    return remote
                        .eraseToAnyPublisher()
                } else {
                    return Just(reactionIcons)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
