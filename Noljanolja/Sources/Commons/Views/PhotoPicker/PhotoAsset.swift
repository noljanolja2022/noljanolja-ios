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

    func requestThumbnail(targetSize: CGSize = CGSize(width: 250, height: 250),
                          contentMode: PHImageContentMode = .aspectFit,
                          options: PHImageRequestOptions? = nil) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            PHImageManager.default().requestImage(
                for: self.asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options
            ) { [weak self] image, _ in
                DispatchQueue.main.async { [weak self] in
                    self?.thumbnail = image
                }
            }
        }
    }
}
