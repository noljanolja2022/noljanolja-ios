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
                    Text("Start Chatting")
                        .font(.system(size: 18, weight: .bold))
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
        HStack {
            Button(
                action: {
                    viewModel.conversationTypeAction.send(.single)
                },
                label: {
                    VStack {
                        ImageAssets.icSingleChat.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 24)

                        Text("Normal Chat")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .frame(maxWidth: .infinity)
                }
            )
            Button(
                action: {
                    viewModel.conversationTypeAction.send(.group)
                },
                label: {
                    VStack {
                        ImageAssets.icGroupChat.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 24)

                        Text("Group Chat")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                    .frame(maxWidth: .infinity)
                }
            )
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(ColorAssets.white.swiftUIColor)
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
