//
//  ForwardView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/07/2023.
//

import SwiftUI

// MARK: - ForwardView

struct ForwardView: View {
    var body: some View {
        HStack(spacing: 4) {
            ImageAssets.icReply.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            Text("Forwarded")
                .font(.system(size: 10))
                .italic()
        }
        .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
    }
}

// MARK: - ForwardView_Previews

struct ForwardView_Previews: PreviewProvider {
    static var previews: some View {
        ForwardView()
    }
}
