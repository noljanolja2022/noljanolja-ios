//
//  ChatImagesView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import SwiftUI

// MARK: - ChatImagesView

struct ChatImagesView<ViewModel: ChatImagesViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - ChatImagesView_Previews

struct ChatImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatImagesView(viewModel: ChatImagesViewModel())
    }
}
