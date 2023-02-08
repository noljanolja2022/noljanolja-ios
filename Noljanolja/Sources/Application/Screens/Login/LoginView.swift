//
//  LoginView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import SwiftUI

// MARK: - LoginView

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel = LoginViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Button(
                action: {
                    viewModel.input.signInWithAppleTrigger.send()
                },
                label: {
                    Text("Sign in with Apple")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 20).bold())
                        .padding(16)
                }
            )
            .background(Color.black)
            Button(
                action: {
                    viewModel.input.signInWithGoogleTrigger.send()
                },
                label: {
                    Text("Sign in with Google")
                        .foregroundColor(Color.black)
                        .font(Font.system(size: 20).bold())
                        .padding(16)
                }
            )
            .background(Color.red)
            Button(
                action: {
                    viewModel.input.signInWithKakaoTrigger.send()
                },
                label: {
                    Text("Sign in with Kakao")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 20).bold())
                        .padding(16)
                }
            )
            .background(Color.yellow)
            Button(
                action: {
                    viewModel.input.signInWithNaverTrigger.send()
                },
                label: {
                    Text("Sign in with Naver")
                        .foregroundColor(Color.black)
                        .font(Font.system(size: 20).bold())
                        .padding(16)
                }
            )
            .background(Color.green)
            Button(
                action: {
                    print("TOKEN TOKEN", AuthStore.default.getToken() ?? "")
                },
                label: {
                    Text("Print token")
                        .foregroundColor(Color.orange)
                        .font(Font.system(size: 20).bold())
                        .padding(16)
                }
            )
            .background(Color.blue)
            Button(
                action: {
                    viewModel.input.signOutTrigger.send(())
                },
                label: {
                    Text("Sign out")
                        .foregroundColor(Color.orange)
                        .font(Font.system(size: 20).bold())
                        .padding(16)
                }
            )
            .background(Color.clear)
        }
    }
}

// MARK: - LoginView_Previews

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
