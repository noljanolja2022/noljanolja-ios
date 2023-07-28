//
//  VideoActionContainerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/07/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - VideoActionContainerView

struct VideoActionContainerView<ViewModel: VideoActionContainerViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .onReceive(viewModel.closeAction) {
                withoutAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                onDismiss: {
                    withoutAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
            .introspectViewController {
                $0.view.backgroundColor = .clear
            }
    }

    private func buildContentView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onPress {
                presentationMode.wrappedValue.dismiss()
            }
    }
}

extension VideoActionContainerView {
    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<VideoActionContainerFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case .more:
            BottomSheet {
                VideoActionView(
                    viewModel: VideoActionViewModel(
                        video: viewModel.video,
                        delegate: viewModel
                    )
                )
            }
        case .share:
            BottomSheet {
                ShareVideoView(
                    viewModel: ShareVideoViewModel(
                        delegate: viewModel
                    )
                )
            }
        case let .shareDetail(model):
            BottomSheet {
                ShareVideoDetailView(
                    viewModel: ShareVideoDetailViewModel(
                        video: viewModel.video,
                        user: model,
                        delegate: viewModel
                    )
                )
            }
        }
    }
}
