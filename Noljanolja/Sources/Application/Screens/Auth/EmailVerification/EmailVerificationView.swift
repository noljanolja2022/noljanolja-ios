//
//  EmailVerificationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/02/2023.
//
//

import SwiftUI

// MARK: - EmailVerificationView

struct EmailVerificationView: View {
    @StateObject private var viewModel: EmailVerificationViewModel

    @Environment(\.scenePhase) var scenePhase
    @Binding private var isShowingEmailVerificationView: Bool

    init(viewModel: EmailVerificationViewModel,
         isShowingEmailVerificationView: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isShowingEmailVerificationView = isShowingEmailVerificationView
    }

    var body: some View {
        VStack(spacing: 0) {
            content
            actions
        }
        .padding(16)
        .onAppear {
            viewModel.sendEmailVerificationTrigger.send(())
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.verifyEmailTrigger.send(())
            }
        }
    }

    private var content: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            ImageAssets.icCheckCircleHightlight.swiftUIImage
                .resizable()
                .scaledToFill()
            
                .frame(width: 62, height: 62)
            Text("Identity verification complete!")
                .font(FontFamily.NotoSans.bold.swiftUIFont(size: 16))
                .multilineTextAlignment(.center)
            Spacer()
        }
    }

    private var actions: some View {
        HStack(spacing: 12) {
            Button(
                L10n.Common.previous,
                action: {
                    viewModel.signUpStep = .second
                    isShowingEmailVerificationView = false
                }
            )
            .frame(width: 100)
            .buttonStyle(ThridyButtonStyle())

            Button(
                "Email verification",
                action: { viewModel.verifyEmailTrigger.send(()) }
            )
            .buttonStyle(PrimaryButtonStyle())
        }
    }
}

// MARK: - EmailVerificationView_Previews

struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationView(
            viewModel: EmailVerificationViewModel(signUpStep: .constant(.third)),
            isShowingEmailVerificationView: .constant(true)
        )
    }
}
