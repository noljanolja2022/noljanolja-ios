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

    private let contactStore: ContactStoreType
    private let conversationStore: ConversationStoreType
    private let conversationDetailStore: ConversationDetailStoreType
    private let mediaStore: MediaStoreType
    private let messageStore: MessageStoreType

    init(contactStore: ContactStoreType = ContactStore.default,
         conversationStore: ConversationStoreType = ConversationStore.default,
         conversationDetailStore: ConversationDetailStoreType = ConversationDetailStore.default,
         mediaStore: MediaStoreType = MediaStore.default,
         messageStore: MessageStoreType = MessageStore.default) {
        self.contactStore = contactStore
        self.conversationStore = conversationStore
        self.conversationDetailStore = conversationDetailStore
        self.mediaStore = mediaStore
        self.messageStore = messageStore
    }

    func deleteCache() {
        contactStore.deleteAll()
        conversationStore.deleteAll()
        conversationDetailStore.deleteAll()
        mediaStore.deleteAll()
        messageStore.deleteAll()
    }
}
