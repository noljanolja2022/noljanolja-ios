//
//  PhotoAssetRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/03/2023.
//

import Combine
import Photos
import UIKit

// MARK: - PhotoAssetRepositoryError

enum PhotoAssetRepositoryError: Error {
    case noUIImage
    case unknown
}

// MARK: - PhotoAssetRepository

final class PhotoAssetRepository {
    static let `default` = PhotoAssetRepository()

    func requestImage(_ assets: [PhotoAsset]) -> AnyPublisher<[PhotoModel]?, Never> {
        AnyPublisher<[PhotoModel]?, Never> { subscriber in
            var photoModels = [PhotoModel?](repeating: nil, count: assets.count)
            var count = 0

            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = false
            DispatchQueue.global(qos: .userInteractive).async {
                assets.forEach { asset in
                    PHImageManager.default()
                        .requestImage(
                            for: asset.asset,
                            targetSize: PHImageManagerMaximumSize,
                            contentMode: .aspectFit,
                            options: options
                        ) { image, _ in
                            let photoModel = image.flatMap { PhotoModel(id: asset.asset.localIdentifier, image: $0) }
                            if let index = assets.firstIndex(where: { $0.asset.localIdentifier == asset.asset.localIdentifier }) {
                                photoModels[index] = photoModel
                            } else {
                                photoModels.append(photoModel)
                            }
                            count += 1

                            if count == assets.count {
                                subscriber.send(photoModels.compactMap { $0 })
                            }
                        }
                }
            }

            return AnyCancellable {}
        }
    }
}
