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
    @StateObject var photoAsset: PhotoAsset
    @Binding var selectedIndex: Int?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                IfLet(
                    $photoAsset.thumbnail,
                    then: { image in
                        Image(uiImage: image.wrappedValue)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .contentShape(Rectangle())
                    },
                    else: {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                )

                IfLet(
                    $selectedIndex,
                    then: { selectedIndex in
                        Text("\(selectedIndex.wrappedValue + 1)")
                            .font(.system(size: 12, weight: .medium))
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .background(.white)
                            .cornerRadius(12)
                    },
                    else: {
                        Spacer()
                            .frame(width: 24, height: 24)
                    }
                )
                .overlayBorder(color: .white, cornerRadius: 12, lineWidth: 2)
                .offset(x: -8, y: 8)
            }
            .onAppear {
                photoAsset.requestThumbnail(targetSize: geometry.size)
            }
        }
        .aspectRatio(1, contentMode: .fill)
    }
}
