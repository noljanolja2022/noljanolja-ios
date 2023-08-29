//
//  ChatAttachmentsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import SwiftUI

// MARK: - ChatAttachmentsView

struct ChatAttachmentsView<ViewModel: ChatAttachmentsViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildMainView()
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Images/Files")
                    .lineLimit(1)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        EmptyView()
    }
}

// MARK: - ChatAttachmentsView_Previews

struct ChatAttachmentsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatAttachmentsView(viewModel: ChatAttachmentsViewModel())
    }
}
