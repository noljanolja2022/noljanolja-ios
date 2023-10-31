//
//  ImagePickerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//

import Photos
import SwiftUI

// MARK: - PhotoPickerView

struct PhotoPickerView: View {
    @State private var assets = [PhotoAsset]()

    @Binding var selectAssets: [PhotoAsset]
    var maxSelectAssets = 10
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .flexible(spacing: 4), count: 3), spacing: 4) {
                ForEach(0..<assets.count, id: \.self) { index in
                    PhotoPickerItemView(
                        photoAsset: assets[index],
                        selectedIndex: Binding<Int?>(
                            get: {
                                selectAssets
                                    .firstIndex(where: { $0.asset.localIdentifier == assets[index].asset.localIdentifier })
                            },
                            set: { _, _ in
                            }
                        )
                    )
                    .onTapGesture {
                        if let selectedIndex = selectAssets
                            .firstIndex(where: { $0.asset.localIdentifier == assets[index].asset.localIdentifier }) {
                            selectAssets.remove(at: selectedIndex)
                        } else if selectAssets.count < maxSelectAssets {
                            selectAssets.append(assets[index])
                        }
                    }
                }
            }
        }
        .onAppear { assets = PhotoLibrary.default.fetchAssets() }
    }
}

// MARK: - PhotoPickerView_Previews

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView(selectAssets: .constant([]))
    }
}
