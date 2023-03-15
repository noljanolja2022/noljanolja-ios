//
//  ChatDateItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import SwiftUI

// MARK: - ChatDateItemView

struct ChatDateItemView: View {
    let dateItemModel: ChatDateItemModel

    var body: some View {
        Text(dateItemModel.displayDateString)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 16)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
    }
}

// MARK: - ChatDateItemView_Previews

struct ChatDateItemView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDateItemView(
            dateItemModel: ChatDateItemModel(
                date: Date()
            )
        )
    }
}
