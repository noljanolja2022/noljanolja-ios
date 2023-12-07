//
//  PHAsset.swift
//  Noljanolja
//
//  Created by kii on 06/12/2023.
//

import Foundation
import Photos
import UIKit

extension PHAsset {
    func requestThumbnail(targetSize: CGSize = CGSize(width: 250, height: 250),
                          contentMode: PHImageContentMode = .aspectFit,
                          options: PHImageRequestOptions? = nil,
                          completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            PHImageManager.default().requestImage(
                for: self,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options
            ) { image, _ in
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
