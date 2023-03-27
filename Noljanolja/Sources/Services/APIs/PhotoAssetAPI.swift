//
//  PhotoAssetAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/03/2023.
//

import Combine
import Photos
import UIKit

// MARK: - PhotoAssetAPIError

enum PhotoAssetAPIError: Error {
    case noUIImage
    case unknown
}

// MARK: - PhotoAssetAPI

final class PhotoAssetAPI {
    static let `default` = PhotoAssetAPI()

    func requestImage(_ assets: [PhotoAsset]) -> AnyPublisher<[PhotoModel]?, Never> {
        AnyPublisher<[PhotoModel]?, Never> { subscriber in
            var photoModels = [PhotoModel?](repeating: nil, count: assets.count)

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

                            if photoModels.count == assets.count {
                                subscriber.send(photoModels.compactMap { $0 })
                            }
                        }
                }
            }

            return AnyCancellable {}
        }
    }
}
