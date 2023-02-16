//
//  EmailVerificationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/02/2023.
//
//

import SwiftUI

// MARK: - EmailVerificationView

struct EmailVerificationView<ViewModel: EmailVerificationViewModelType>: View {
    // MARK: View Model

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @Environment(\.scenePhase) var scenePhase
    @Environment(\.presentationMode) private var presentationMode

    init(viewModel: ViewModel = EmailVerificationViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            content
            actions
        }
        .padding(16)
        .onAppear {
            viewModel.updateSignUpStepTrigger.send(.third)
            viewModel.sendEmailVerificationTrigger.send(())
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.checkEmailVerificationTrigger.send(())
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
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .frame(width: 100)
            .buttonStyle(ThridyButtonStyle())

            Button(
                "Email verification",
                action: { viewModel.checkEmailVerificationTrigger.send(()) }
            )
            .buttonStyle(PrimaryButtonStyle())
        }
    }
}

// MARK: - EmailVerificationView_Previews

struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationView()
    }
}
