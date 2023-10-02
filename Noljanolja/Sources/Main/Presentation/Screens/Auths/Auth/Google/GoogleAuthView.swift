//
//  GoogleAuthView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/10/2023.
//
//

import SwiftUI

// MARK: - GoogleAuthView

struct GoogleAuthView<ViewModel: GoogleAuthViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - GoogleAuthView_Previews

struct GoogleAuthView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuthView(viewModel: GoogleAuthViewModel())
    }
}
