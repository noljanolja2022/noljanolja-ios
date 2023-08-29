//
//  ChatFilesView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import SwiftUI

// MARK: - ChatFilesView

struct ChatFilesView<ViewModel: ChatFilesViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - ChatFilesView_Previews

struct ChatFilesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatFilesView(viewModel: ChatFilesViewModel())
    }
}
