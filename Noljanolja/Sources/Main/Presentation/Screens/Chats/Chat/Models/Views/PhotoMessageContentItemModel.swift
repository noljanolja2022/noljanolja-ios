//
//  File.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/07/2023.
//

import Foundation

struct PhotoMessageContentItemModel {
    let url: URL?
    let overlayText: String?
    let createdAt: Date
    let status: MessageStatusModel.StatusType
    
    init(url: URL?,
         overlayText: String? = nil,
         createdAt: Date,
         status: MessageStatusModel.StatusType) {
        self.url = url
        self.overlayText = overlayText
        self.createdAt = createdAt
        self.status = status
    }
}
