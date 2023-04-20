//
//  MediaType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//

import Foundation

// MARK: - ChatMediaInputType

enum ChatMediaInputType {
    case photo
    case sticker
}

// MARK: - ChatInputExpandType

enum ChatInputExpandType: Equatable {
    case menu
    case sticker
    case images
}
