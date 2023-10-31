//
//  DeleteCacheUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//

import Foundation

// MARK: - DeleteCacheUseCaseProtocol

protocol DeleteCacheUseCaseProtocol {
    func deleteCache()
}

// MARK: - DeleteCacheUseCase

final class DeleteCacheUseCase: DeleteCacheUseCaseProtocol {
    static let `default` = DeleteCacheUseCase()

    private let contactLocalRepository: ContactLocalRepository
    private let conversationLocalRepository: ConversationLocalRepository
    private let localDetailConversationRepository: LocalDetailConversationRepository
    private let localMediaRepository: LocalMediaRepository
    private let localMessageRepository: LocalMessageRepository

    init(contactLocalRepository: ContactLocalRepository = ContactLocalRepositoryImpl.default,
         conversationLocalRepository: ConversationLocalRepository = ConversationLocalRepositoryImpl.default,
         localDetailConversationRepository: LocalDetailConversationRepository = LocalDetailConversationRepositoryImpl.default,
         localMediaRepository: LocalMediaRepository = LocalMediaRepositoryImpl.default,
         localMessageRepository: LocalMessageRepository = LocalMessageRepositoryImpl.default) {
        self.contactLocalRepository = contactLocalRepository
        self.conversationLocalRepository = conversationLocalRepository
        self.localDetailConversationRepository = localDetailConversationRepository
        self.localMediaRepository = localMediaRepository
        self.localMessageRepository = localMessageRepository
    }

    func deleteCache() {
        contactLocalRepository.deleteAll()
        conversationLocalRepository.deleteAll()
        localDetailConversationRepository.deleteAll()
        localMediaRepository.deleteAll()
        localMessageRepository.deleteAll()
    }
}
