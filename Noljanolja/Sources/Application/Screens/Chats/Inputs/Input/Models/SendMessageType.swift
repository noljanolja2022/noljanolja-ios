//
//  SendMessageType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/04/2023.
//

import Foundation
import UIKit

enum SendMessageType {
    case text(String)
    case images([UIImage])
    case photoAssets([PhotoAsset])
    case sticker(StickerPack, Sticker)
}
