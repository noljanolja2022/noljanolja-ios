//
//  ForgotPasswordView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import SwiftUI

// MARK: - ForgotPasswordView

struct ForgotPasswordView: View {
    @StateObject private var viewModel: ForgotPasswordViewModel

    init(viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Text("Hello, World!")
    }
}

// MARK: - ForgotPasswordView_Previews

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
