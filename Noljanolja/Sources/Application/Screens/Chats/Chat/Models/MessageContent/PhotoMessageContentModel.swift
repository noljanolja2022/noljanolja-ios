//
//  Photo.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import Foundation

// MARK: - TextMessageContentModel

struct PhotoMessageContentModel: Equatable {
    let isSendByCurrentUser: Bool
    let photoLists: [[URL?]]
    let createdAt: Date
    let status: MessageStatusModel.StatusType
    let isShareHidden: Bool
    let background: MessageContentBackgroundModel

    init(currentUser: User,
         message: Message,
         status: NormalMessageModel.StatusType,
         background: MessageContentBackgroundModel) {
        self.isSendByCurrentUser = currentUser.id == message.sender.id
        self.photoLists = {
            let numberItemOfRow = 2
            var photoLists = [[URL?]]()
            var photos = [URL?]()
            let items = message.attachments
            items.enumerated().forEach { index, element in
                if photos.count == numberItemOfRow {
                    photoLists.append(photos)
                    photos = [URL?]()
                }
                photos.append(element.getPhotoURL(conversationID: message.conversationID))
                if index == items.count - 1 {
                    if !photoLists.isEmpty, numberItemOfRow - photos.count > 0 {
                        let remainPhotos = [URL?](repeating: nil, count: numberItemOfRow - photos.count)
                        photos.append(contentsOf: remainPhotos)
                    }
                    photoLists.append(photos)
                }
            }
            return photoLists
        }()
        self.createdAt = message.createdAt
        self.status = {
            guard message.sender.id == currentUser.id else {
                return .none
            }
            switch status {
            case .none, .sending, .sent: return .none
            case let .seen(users): return .seen(.single(!users.isEmpty))
            }
        }()
        self.isShareHidden = message.sender.id != currentUser.id
        self.background = background
    }
}
