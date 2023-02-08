//
//  SignInView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Introspect
import SwiftUI

// MARK: - SignInView

struct SignInView: View {
    @StateObject private var viewModel: SignInViewModel

    @State private var email = ""
    @State private var password = ""

    init(viewModel: SignInViewModel = SignInViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
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
            ZStack(alignment: .trailing) {
                Button(
                    action: {
                        viewModel.signInWithEmailPasswordTrigger.send((email, password))
                    },
                    label: {
                        Text("Forgot password")
                            .font(Font.system(size: 16).italic())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
            }
            .frame(height: 20)
            Button(
                action: {
                    viewModel.signInWithEmailPasswordTrigger.send((email, password))
                },
                label: {
                    Text("Sign In")
                        .font(Font.system(size: 16).bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
            .frame(height: 48)
            .background(Color.green)
            .cornerRadius(8)
            .padding(.vertical, 4)

            HStack {
                Rectangle()
                    .frame(height: 1)
                    .overlay(Color.gray)
                    .padding(8)
                Text("OR")
                    .font(Font.system(size: 16))
                    .foregroundColor(.gray)
                Rectangle()
                    .frame(height: 1)
                    .overlay(Color.gray)
                    .padding(8)
            }
            .padding(.vertical, 12)

            HStack(spacing: 16) {
                Button(
                    action: {
                        viewModel.signInWithAppleTrigger.send()
                    },
                    label: {
                        Text("A")
                            .font(Font.system(size: 20).bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                .frame(width: 48, height: 48)
                .background(Color.black)
                .cornerRadius(32)
                Button(
                    action: {
                        viewModel.signInWithGoogleTrigger.send()
                    },
                    label: {
                        Text("G")
                            .font(Font.system(size: 20).bold())
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                .frame(width: 48, height: 48)
                .background(Color.white)
                .cornerRadius(32)
                Button(
                    action: {
                        viewModel.signInWithKakaoTrigger.send()
                    },
                    label: {
                        Text("K")
                            .font(Font.system(size: 20).bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                .frame(width: 48, height: 48)
                .background(Color.yellow)
                .cornerRadius(32)
                Button(
                    action: {
                        viewModel.signInWithNaverTrigger.send()
                    },
                    label: {
                        Text("N")
                            .font(Font.system(size: 20).bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                .frame(width: 48, height: 48)
                .background(Color.green)
                .cornerRadius(32)
            }
        }
        .frame(maxHeight: .infinity)
        .padding(16)
    }
}

// MARK: - SignInView_Previews

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
