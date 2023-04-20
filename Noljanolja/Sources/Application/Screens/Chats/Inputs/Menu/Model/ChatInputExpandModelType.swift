//
//  ChatInputExpandModelType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/04/2023.
//

import Foundation

enum ChatInputExpandModelType: CaseIterable, Equatable {
    case image
    case camera

    var imageName: String {
        switch self {
        case .image:
            return ImageAssets.icPhotoOutline.name
        case .camera:
            return ImageAssets.icCameraOutline.name
        }
    }

    var colorHexString: String {
        switch self {
        case .image: return "86D558"
        case .camera: return "6892DE"
        }
    }

    var title: String {
        switch self {
        case .image: return "Album"
        case .camera: return "Camera"
        }
    }
}
