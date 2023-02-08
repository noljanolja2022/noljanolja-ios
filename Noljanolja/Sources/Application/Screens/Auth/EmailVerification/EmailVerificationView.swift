//
//  EmailVerificationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import SwiftUI

// MARK: - EmailVerificationView

struct EmailVerificationView: View {
    @StateObject private var viewModel: EmailVerificationViewModel

    @State private var code = ""

    init(viewModel: EmailVerificationViewModel = EmailVerificationViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            Text("Please verify your email first\nEmail has been sent to your email. Please follow and verify email and sign in again")
                .font(Font.system(size: 16))
        }
        .onAppear {
            viewModel.sendEmailVerificationTrigger.send(())
        }
    }
}

// MARK: - EmailVerificationView_Previews

struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationView()
    }
}
