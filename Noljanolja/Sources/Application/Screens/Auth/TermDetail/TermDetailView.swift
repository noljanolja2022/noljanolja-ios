//
//  TermDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/02/2023.
//
//

import SwiftUI

// MARK: - TermDetailView

struct TermDetailView: View {
    @StateObject private var viewModel: TermDetailViewModel

    var termAndCoditionItemType: TermAndCoditionItemType

    init(viewModel: TermDetailViewModel = TermDetailViewModel(),
         termAndCoditionItemType: TermAndCoditionItemType) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.termAndCoditionItemType = termAndCoditionItemType
    }

    var body: some View {
        ScrollView {
            Text(termAndCoditionItemType.content)
                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 11))
                .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                .padding(16)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("") {}
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(termAndCoditionItemType.title)
                    Text(termAndCoditionItemType.description)
                }
                .font(FontFamily.NotoSans.bold.swiftUIFont(size: 16))
            }
        }
        .navigationBarHidden(false)
    }
}

// MARK: - TermDetailView_Previews

struct TermDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TermDetailView(termAndCoditionItemType: .termOfService)
    }
}
