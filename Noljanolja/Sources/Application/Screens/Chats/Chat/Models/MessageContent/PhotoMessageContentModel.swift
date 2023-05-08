//
//  Photo.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import Foundation

// MARK: - TextMessageContentModel

struct PhotoMessageContentModel: Equatable {
    let photoLists: [[URL?]]
    let createdAt: Date
    let seenByType: SeenByType?

    init(currentUser: User, message: Message, seenByType: SeenByType?) {
        let numberItemOfRow = 3

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
                if photoLists.count > 1 {
                    let remainPhotos = [URL?](repeating: nil, count: numberItemOfRow - photos.count)
                    photos.append(contentsOf: remainPhotos)
                }
                photoLists.append(photos)
            }
        }

        self.photoLists = photoLists
        self.createdAt = message.createdAt
        self.seenByType = seenByType
    }
}
