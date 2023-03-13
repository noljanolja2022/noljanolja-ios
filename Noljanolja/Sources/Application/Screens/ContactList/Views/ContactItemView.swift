//
//  ContactItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import SwiftUI

// MARK: - ContactItemView

struct ContactItemView: View {
    var image: UIImage?
    var name: String?

    var body: some View {
        VStack {
            Text(name ?? "")
                .height(48)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16))

            Divider()
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - ContactItemView_Previews

struct ContactItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContactItemView(
            name: "Hola"
        )
    }
}
