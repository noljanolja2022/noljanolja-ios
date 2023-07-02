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
    private let reactionIconsLocalRepository: ReactionIconsLocalRepositoryProtocol

    init(reactionIconsRemoteRepository: ReactionIconsRemoteRepositoryProtocol = ReactionIconsRemoteRepository.default,
         reactionIconsLocalRepository: ReactionIconsLocalRepositoryProtocol = ReactionIconsLocalRepository.default) {
        self.reactionIconsRemoteRepository = reactionIconsRemoteRepository
        self.reactionIconsLocalRepository = reactionIconsLocalRepository
    }

    func getReactionIcons() -> AnyPublisher<[ReactIcon], Error> {
        let local = reactionIconsLocalRepository
            .observeReactIcons()
            .filter { !$0.isEmpty }
        let remote = reactionIconsRemoteRepository
            .getReactIcons()
            .handleEvents(receiveOutput: { [weak self] in
                self?.reactionIconsLocalRepository.saveReactIcons($0)
            })
        return Publishers.Amb(first: local, second: remote)
            .eraseToAnyPublisher()
    }
}
