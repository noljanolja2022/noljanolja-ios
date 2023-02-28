//
//  AuthPopupView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/02/2023.
//
//

import SwiftUI

// MARK: - AuthPopupView

struct AuthPopupView<ViewModel: AuthPopupViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    init(viewModel: ViewModel = AuthPopupViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            VStack(alignment: .trailing, spacing: 8) {
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text(L10n.Common.close)
                            .padding(.horizontal, 20)
                    }
                )
                .buttonStyle(PlainButtonStyle())

                VStack(spacing: 0) {
                    Text("Let's Play Start the service")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 20))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 24)
                    Text("Log in to play\nUse a variety of services!")
                        .font(FontFamily.NotoSans.regular.swiftUIFont(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 42)
                    Button(
                        action: {
                            presentationMode.wrappedValue.dismiss()
                            viewModel.routeToAuthTrigger.send()
                        },
                        label: {
                            Text("Let's Play Log in")
                                .frame(height: 52)
                        }
                    )
                    .buttonStyle(PrimaryButtonStyle())
                    .cornerRadius(26)
                }
                .padding(.top, 52)
                .padding(.horizontal, 58)
                .padding(.bottom, 8)
                .background(
                    Color.white
                        .cornerRadius(24, corners: [.topLeft, .topRight])
                        .ignoresSafeArea()
                )
            }
        }
        .background(Color.clear)
        .introspectViewController { viewController in
            viewController.view.backgroundColor = .clear
        }
    }
}

// MARK: - AuthPopupView_Previews

struct AuthPopupView_Previews: PreviewProvider {
    static var previews: some View {
        AuthPopupView()
    }
}
