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

    private let localContactRepository: LocalContactRepository
    private let conversationStore: ConversationStoreType
    private let conversationDetailStore: ConversationDetailStoreType
    private let localMediaRepository: LocalMediaRepository
    private let localMessageRepository: LocalMessageRepository

    init(localContactRepository: LocalContactRepository = LocalContactRepositoryImpl.default,
         conversationStore: ConversationStoreType = ConversationStore.default,
         conversationDetailStore: ConversationDetailStoreType = ConversationDetailStore.default,
         localMediaRepository: LocalMediaRepository = LocalMediaRepositoryImpl.default,
         localMessageRepository: LocalMessageRepository = LocalMessageRepositoryImpl.default) {
        self.localContactRepository = localContactRepository
        self.conversationStore = conversationStore
        self.conversationDetailStore = conversationDetailStore
        self.localMediaRepository = localMediaRepository
        self.localMessageRepository = localMessageRepository
    }

    func deleteCache() {
        localContactRepository.deleteAll()
        conversationStore.deleteAll()
        conversationDetailStore.deleteAll()
        localMediaRepository.deleteAll()
        localMessageRepository.deleteAll()
    }
}
