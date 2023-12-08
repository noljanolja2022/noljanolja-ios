//
//  PhotoPickerItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//

import Photos
import SwiftUI
import SwiftUINavigation

// MARK: - PhotoPickerItemView

struct PhotoPickerItemView: View {
    let isMultipleSelection: Bool
    @StateObject var photoAsset: PhotoAsset
    @Binding var selectedIndex: Int?
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                IfLet(
                    $photoAsset.thumbnail,
                    then: { image in
                        ZStack {
                            Image(uiImage: image.wrappedValue)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                                .contentShape(Rectangle())
                            IfLet($selectedIndex) { _ in
                                ColorAssets.neutralLight.swiftUIColor
                                    .opacity(0.5)
                            }
                        }

                    },
                    else: {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                )
                if isMultipleSelection {
                    IfLet(
                        $selectedIndex,
                        then: { selectedIndex in
                            Text("\(selectedIndex.wrappedValue + 1)")
                                .dynamicFont(.systemFont(ofSize: 12, weight: .medium))
                                .frame(width: 24, height: 24)
                                .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                                .background(ColorAssets.primaryGreen100.swiftUIColor)
                                .cornerRadius(12)
                                .overlayBorder(
                                    color: ColorAssets.primaryGreen100.swiftUIColor,
                                    cornerRadius: 12,
                                    lineWidth: 2
                                )
                        },
                        else: {
                            Spacer()
                                .frame(width: 24, height: 24)
                                .overlayBorder(
                                    color: ColorAssets.neutralLightGrey.swiftUIColor,
                                    cornerRadius: 12,
                                    lineWidth: 2
                                )
                        }
                    )
                    .offset(x: -8, y: 8)
                }
            }
            .onAppear {
                photoAsset.requestThumbnail(targetSize: geometry.size)
            }
        }
        .aspectRatio(1, contentMode: .fill)
    }
}
