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
    var isMultipleSelection = true

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .flexible(spacing: 4), count: 3), spacing: 4) {
                ForEach(0..<assets.count, id: \.self) { index in
                    PhotoPickerItemView(
                        isMultipleSelection: isMultipleSelection,
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
                        if isMultipleSelection {
                            if let selectedIndex = selectAssets
                                .firstIndex(where: { $0.asset.localIdentifier == assets[index].asset.localIdentifier }) {
                                selectAssets.remove(at: selectedIndex)
                            } else if selectAssets.count < maxSelectAssets {
                                selectAssets.append(assets[index])
                            }
                        } else {
                            selectAssets = [assets[index]]
                        }
                    }
                }
            }
        }
        .onAppear {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        DispatchQueue.main.async {
                            assets = PhotoLibrary.default.fetchAssets()
                        }
                    }
                }
            case .restricted, .denied:
                break
            case .authorized:
                assets = PhotoLibrary.default.fetchAssets()
            default:
                break
            }
        }
    }
}

// MARK: - PhotoPickerView_Previews

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView(selectAssets: .constant([]))
    }
}
