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
    private let detailConversationLocalRepository: DetailConversationLocalRepository
    private let mediaLocalRepository: MediaLocalRepository
    private let messageLocalRepository: MessageLocalRepository

    init(contactLocalRepository: ContactLocalRepository = ContactLocalRepositoryImpl.default,
         conversationLocalRepository: ConversationLocalRepository = ConversationLocalRepositoryImpl.default,
         detailConversationLocalRepository: DetailConversationLocalRepository = DetailConversationLocalRepositoryImpl.default,
         mediaLocalRepository: MediaLocalRepository = MediaLocalRepositoryImpl.default,
         messageLocalRepository: MessageLocalRepository = MessageLocalRepositoryImpl.default) {
        self.contactLocalRepository = contactLocalRepository
        self.conversationLocalRepository = conversationLocalRepository
        self.detailConversationLocalRepository = detailConversationLocalRepository
        self.mediaLocalRepository = mediaLocalRepository
        self.messageLocalRepository = messageLocalRepository
    }

    func deleteCache() {
        contactLocalRepository.deleteAll()
        conversationLocalRepository.deleteAll()
        detailConversationLocalRepository.deleteAll()
        mediaLocalRepository.deleteAll()
        messageLocalRepository.deleteAll()
    }
}
