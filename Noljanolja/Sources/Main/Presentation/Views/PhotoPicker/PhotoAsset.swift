//
//  PhotoAsset.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//

import Foundation
import Photos
import UIKit

final class PhotoAsset: ObservableObject {
    let asset: PHAsset

    @Published var thumbnail: UIImage?

    init(asset: PHAsset) {
        self.asset = asset
    }

    func requestThumbnail(targetSize: CGSize) {
        asset.requestThumbnail(targetSize: targetSize) { [weak self] image in
            guard let self else { return }
            self.thumbnail = image
        }
    }
}
