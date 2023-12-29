//
//  ChatAttachmentsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import SwiftUI

// MARK: - ChatAttachmentsView

struct ChatAttachmentsView<ViewModel: ChatAttachmentsViewModel>: View {
    // MARK: Dependencies

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildMainView()
        }
        .navigationBar(title: "Images/Files", backButtonTitle: "", presentationMode: presentationMode, trailing: {})
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        VStack(spacing: 8) {
            buildHeaderView()
            buildContentView()
        }
    }

    private func buildHeaderView() -> some View {
        HStack(spacing: 8) {
            ForEach(viewModel.allAttachmentTypes.indices, id: \.self) { index in
                buildHeaderItemView(viewModel.allAttachmentTypes[index])
            }
        }
        .frame(height: 40)
        .padding(.top, 8)
    }

    private func buildHeaderItemView(_ type: ConversationAttachmentType) -> some View {
        Button(
            action: {
                viewModel.selectedAttachmentType = type
            },
            label: {
                VStack(spacing: 8) {
                    Text(type.title)
                        .dynamicFont(.systemFont(
                            ofSize: 14,
                            weight: type == viewModel.selectedAttachmentType ? .bold : .regular
                        ))
                        .multilineTextAlignment(.center)
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .frame(maxHeight: .infinity)

                    Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: 2)
                        .background(type == viewModel.selectedAttachmentType ? ColorAssets.primaryGreen200.swiftUIColor : .clear)
                }
                .frame(maxHeight: .infinity)
            }
        )
    }

    private func buildContentView() -> some View {
        TabView(selection: $viewModel.selectedAttachmentType) {
            if viewModel.allAttachmentTypes.contains([.photo]) {
                ChatImagesView(
                    viewModel: ChatAttachmentTabViewModel(
                        conversation: viewModel.conversation,
                        type: .photo
                    )
                )
                .tag(ConversationAttachmentType.photo)
            }
            if viewModel.allAttachmentTypes.contains([.file]) {
                ChatFilesView(
                    viewModel: ChatAttachmentTabViewModel(
                        conversation: viewModel.conversation,
                        type: .file
                    )
                )
                .tag(ConversationAttachmentType.file)
            }
            if viewModel.allAttachmentTypes.contains([.link]) {
                ChatLinksView(
                    viewModel: ChatAttachmentTabViewModel(
                        conversation: viewModel.conversation,
                        type: .link
                    )
                )
                .tag(ConversationAttachmentType.link)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
