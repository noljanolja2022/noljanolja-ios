//
//  ChatLinksView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import SwiftUI

// MARK: - ChatLinksView

struct ChatLinksView<ViewModel: ChatLinksViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - ChatLinksView_Previews

struct ChatLinksView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLinksView(viewModel: ChatLinksViewModel())
    }
}
