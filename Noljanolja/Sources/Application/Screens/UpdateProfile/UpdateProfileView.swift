//
//  UpdateProfileView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/03/2023.
//
//

import SwiftUI

// MARK: - UpdateProfileView

struct UpdateProfileView<ViewModel: UpdateProfileViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = UpdateProfileViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                
            }
        }
    }
}

// MARK: - UpdateProfileView_Previews

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView()
    }
}
