//
//  ConversationTitleView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - ConversationTitleView

struct ConversationTitleView<ViewModel: ConversationTitleViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var progressHUBState = ProgressHUBState()

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Change title")
                        .lineLimit(1)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onReceive(viewModel.closeSubject) {
                presentationMode.wrappedValue.dismiss()
            }
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .progressHUB(isActive: $progressHUBState.isLoading)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            CocoaTextField("Title", text: $viewModel.title)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
                .frame(height: 48)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(6)

            Spacer()

            Button(
                "SAVE",
                action: { viewModel.actionSubject.send() }
            )
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(16)
    }
}

// MARK: - ConversationTitleView_Previews

struct ConversationTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationTitleView(
            viewModel: ConversationTitleViewModel(
                conversation: Conversation(
                    id: 0,
                    title: nil,
                    creator: User(
                        id: "",
                        name: nil,
                        avatar: nil,
                        pushToken: nil,
                        phone: nil,
                        email: nil,
                        isEmailVerified: false,
                        dob: nil,
                        gender: nil,
                        preferences: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    ),
                    admin: User(
                        id: "",
                        name: nil,
                        avatar: nil,
                        pushToken: nil,
                        phone: nil,
                        email: nil,
                        isEmailVerified: false,
                        dob: nil,
                        gender: nil,
                        preferences: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    ),
                    type: .single,
                    messages: [],
                    participants: [],
                    createdAt: Date(),
                    updatedAt: Date()
                )
            )
        )
    }
}
