//
//  ProfileItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//

import SwiftUI

// MARK: - ProfileItemView

struct ProfileItemView: View {
    var imageName: String
    var title: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Text(title)
                        .font(FontFamily.NotoSans.medium.swiftUIFont(fixedSize: 16))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing, 12)
                Divider()
                    .background(Color.black)
            }
        }
        .padding(.leading, 12)
        .foregroundColor(Color.black)
        .frame(height: 64)
    }
}

// MARK: - ProfileItemView_Previews

struct ProfileItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileItemView(
            imageName: "applepencil",
            title: "Edit"
        )
    }
}
