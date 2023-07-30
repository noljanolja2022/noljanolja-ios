//
//  ChatInputExpandModelType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/04/2023.
//

import Foundation
import SwiftUI

enum ChatInputExpandModelType: CaseIterable, Equatable {
    case image
    case camera
    case events
    case wallet
    case location
    case voice
    case contact
    case file

    var imageName: String {
        switch self {
        case .image: return ImageAssets.icChatImage.name
        case .camera: return ImageAssets.icChatCamera.name
        case .events: return ImageAssets.icChatEvent.name
        case .wallet: return ImageAssets.icChatWallet.name
        case .location: return ImageAssets.icChatLocation.name
        case .voice: return ImageAssets.icChatVoice.name
        case .contact: return ImageAssets.icChatContact.name
        case .file: return ImageAssets.icChatFile.name
        }
    }

    var backgroundColor: String {
        switch self {
        case .image: return "86D558"
        case .camera: return "6892DE"
        case .events: return "39C65A"
        case .wallet: return "F8DF00"
        case .location: return "52B49D"
        case .voice: return "FB9E65"
        case .contact: return "6595F5"
        case .file: return "D47DE6"
        }
    }

    var title: String {
        switch self {
        case .image: return L10n.chatActionAlbum
        case .camera: return L10n.chatActionCamera
        case .events: return L10n.chatActionEvents
        case .wallet: return L10n.chatActionWallet
        case .location: return L10n.chatActionLocation
        case .voice: return L10n.chatActionVoiceChat
        case .contact: return L10n.chatActionContacts
        case .file: return L10n.chatActionFile
        }
    }
}
