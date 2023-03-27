//
//  PhotoLibrary.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//

import Foundation
import Photos

class PhotoLibrary {
    static let `default` = PhotoLibrary()
    
    func fetchAssets() -> [PhotoAsset] {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let assets = PHAsset.fetchAssets(with: options)
        
        var photoAssets = [PhotoAsset]()
        assets.enumerateObjects { asset, _, _ in
            photoAssets.append(PhotoAsset(asset: asset))
        }

        return photoAssets
    }
}
