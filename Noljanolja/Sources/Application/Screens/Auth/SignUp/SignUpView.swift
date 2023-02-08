//
//  SignUpView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//
//

import SwiftUI

// MARK: - SignUpView

struct SignUpView: View {
    @StateObject private var viewModel: SignUpViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    init(viewModel: SignUpViewModel = SignUpViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $email)
                .font(Font.system(size: 16))
                .frame(height: 48)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            SecureField("Password", text: $password)
                .font(Font.system(size: 16))
                .frame(height: 48)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            SecureField("Confirm password", text: $confirmPassword)
                .font(Font.system(size: 16))
                .frame(height: 48)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )

            Button(
                action: {
                    viewModel.signUpTrigger.send((email, password))
                },
                label: {
                    Text("Sign Up")
                        .font(Font.system(size: 16).bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
            .frame(height: 48)
            .background(Color.green)
            .cornerRadius(8)
            .padding(.vertical, 4)
        }
        .frame(maxHeight: .infinity)
        .padding(16)
    }
}

// MARK: - SignUpView_Previews

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
