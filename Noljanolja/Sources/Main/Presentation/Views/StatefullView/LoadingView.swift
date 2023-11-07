//
//  LoadingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//

import SwiftUI

// MARK: - LoadingView

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
    }
}

// MARK: - LoadingView_Previews

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
