//
//  PhotoMessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import Kingfisher
import SwiftUI

// MARK: - PhotoMessageContentView

struct PhotoMessageContentView: View {
    var contentItemModel: PhotoMessageContentModel

    var body: some View {
        let photosList: [[String?]] = {
            if contentItemModel.photos.count < 3 {
                return [contentItemModel.photos]
            }
            var photosList = [[String?]]()
            var photos = [String?]()
            contentItemModel.photos.forEach { photo in
                photos.append(photo)

                if photos.count == 3 {
                    photosList.append(photos)
                    photos = [String]()
                }
            }
            if !photos.isEmpty {
                let remainCount = 3 - photos.count
                let remainItems = [String?](repeating: nil, count: remainCount)
                photos.append(contentsOf: remainItems)
                photosList.append(photos)
            }
            return photosList
        }()

        return VStack(spacing: 4) {
            ForEach(Array(photosList.enumerated()), id: \.offset) { _, photos in
                HStack(spacing: 4) {
                    ForEach(photos, id: \.self) { photo in
                        GeometryReader { geometry in
                            if let photo {
                                KFImage(URL(string: photo))
                                    .downsampling(size: geometry.size)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .clipped()
                                    .contentShape(Rectangle())
                                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                            } else {
                                Text("")
                            }
                        }
                        .aspectRatio(1, contentMode: .fill)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    //    var body: some View {
    //        LazyVGrid(
    //            columns: Array(repeating: .flexible(spacing: 4), count: min(contentItemModel.photos.count, 3)),
    //            spacing: 4
    //        ) {
    //            ForEach(contentItemModel.photos, id: \.self) { photo in
    //                GeometryReader { geometry in
    //                    KFImage
    //                        .auth(URL(string: photo))
    //                        .downsampling(size: geometry.size)
    //                        .cancelOnDisappear(true)
    //                        .resizable()
    //                        .aspectRatio(contentMode: .fill)
    //                        .frame(width: geometry.size.width, height: geometry.size.height)
    //                        .clipped()
    //                        .contentShape(Rectangle())
    //                        .background(ColorAssets.neutralLightGrey.swiftUIColor)
    //                }
    //                .aspectRatio(1, contentMode: .fill)
    //            }
    //        }
    //        .frame(maxWidth: .infinity)
    //    }
}

// MARK: - PhotoMessageContentView_Previews

struct PhotoMessageContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoMessageContentView(
            contentItemModel: PhotoMessageContentModel(isSenderMessage: true, photos: [])
        )
    }
}
