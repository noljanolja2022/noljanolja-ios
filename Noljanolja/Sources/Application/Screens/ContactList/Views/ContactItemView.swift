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
        HStack(spacing: 16) {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 52, height: 52)
                    .background(Color.gray)
                    .cornerRadius(26)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 8)
                    .frame(width: 52, height: 52)
                    .background(Color.gray)
                    .cornerRadius(26)
            }
            Text(name ?? "")
                .font(.system(size: 18).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
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
