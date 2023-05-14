//
//  ChatInputExpandMenuView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/04/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - ChatInputExpandMenuView

struct ChatInputExpandMenuView<ViewModel: ChatInputExpandMenuViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @Binding var expandType: ChatInputExpandType?

    // MARK: State

    @State var models = ChatInputExpandModelType.allCases
    @State var image: UIImage?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: .flexible(spacing: 20), count: 4),
                spacing: 20
            ) {
                ForEach(models, id: \.self) { model in
                    buildItem(model)
                }
            }
            .padding(24)
        }
        .fullScreenCover(
            unwrapping: $viewModel.fullScreenCoverType,
            onDismiss: {
                guard let image else { return }
                viewModel.fullScreenCoverType = .imagePreview(image)
                self.image = nil
            },
            content: {
                buildFullScreenCoverDestinationView($0)
            }
        )
    }

    private func buildItem(_ model: ChatInputExpandModelType) -> some View {
        Button(
            action: {
                switch model {
                case .image:
                    expandType = .images
                case .camera:
                    viewModel.fullScreenCoverType = .camera
                case .events, .wallet, .location, .voice, .contact, .file:
                    break
                }
            },
            label: {
                VStack(spacing: 12) {
                    Image(model.imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .frame(width: 48, height: 48)
                        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                        .background(Color(hexadecimal: model.backgroundColor))
                        .cornerRadius(16)
                    Text(model.title)
                        .font(.system(size: 14))
                        .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                }
            }
        )
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ChatInputExpandMenuFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case .camera:
            ImagePicker(image: $image)
                .sourceType({
                    #if targetEnvironment(simulator)
                        return .photoLibrary
                    #else
                        return .camera
                    #endif
                }())
                .allowsEditing(false)
                .introspectViewController { $0.view.backgroundColor = .black }
        case let .imagePreview(image):
            ChatInputImagePreviewView(
                viewModel: ChatInputImagePreviewViewModel(
                    image: image,
                    delegate: viewModel
                )
            )
            .introspectViewController { $0.view.backgroundColor = .black }
        }
    }
}

// MARK: - ChatInputExpandMenuView_Previews

struct ChatInputExpandMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ChatInputExpandMenuView(
            viewModel: ChatInputExpandMenuViewModel(),
            expandType: .constant(.sticker)
        )
    }
}
