//
//  CreateConversationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/04/2023.
//
//

import SwiftUI

// MARK: - CreateConversationView

struct CreateConversationView<ViewModel: CreateConversationViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Image(systemName: "xmark")
                        }
                    )
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                ToolbarItem(placement: .principal) {
                    Text(L10n.contactsStartChat)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        ZStack(alignment: .top) {
            buildBackgroundView()
            buildMainView()
        }
    }

    @ViewBuilder
    private func buildBackgroundView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ColorAssets.neutralDarkGrey.swiftUIColor
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.bottom)
            )
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }

    @ViewBuilder
    private func buildMainView() -> some View {
        HStack(spacing: 12) {
            Button(
                action: {
                    viewModel.conversationTypeAction.send(.single)
                },
                label: {
                    HStack(spacing: 12) {
                        ImageAssets.icChatNewSingle.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 21)

                        Text(L10n.contactsTitleNormal)
                            .dynamicFont(.systemFont(ofSize: 14))
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                    .background(ColorAssets.primaryGreen100.swiftUIColor)
                    .cornerRadius(10)
                }
            )
            Button(
                action: {
                    viewModel.conversationTypeAction.send(.group)
                },
                label: {
                    HStack(spacing: 12) {
                        ImageAssets.icChatNewGroup.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 21, height: 21)

                        Text(L10n.contactsTitleGroup)
                            .dynamicFont(.systemFont(ofSize: 14))
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                    .background(ColorAssets.secondaryYellow300.swiftUIColor)
                    .cornerRadius(10)
                }
            )
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorAssets.neutralLight.swiftUIColor)
    }
}

// MARK: - CreateConversationView_Previews

struct CreateConversationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateConversationView(
                viewModel: CreateConversationViewModel()
            )
        }
    }
}