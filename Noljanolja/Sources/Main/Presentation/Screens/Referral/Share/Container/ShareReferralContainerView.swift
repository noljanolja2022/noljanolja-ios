//
//  ShareReferralContainerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/08/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - ShareReferralContainerView

struct ShareReferralContainerView<ViewModel: ShareReferralContainerViewModel>: View {
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
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }
}

extension ShareReferralContainerView {
    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ShareReferralContainerFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case .horizontalShare:
            BottomSheet {
                HorizontalShareReferralView(
                    viewModel: HorizontalShareReferralViewModel(
                        code: viewModel.code,
                        delegate: viewModel
                    )
                )
            }
        case .verticalShare:
            BottomSheet {
                VerticalShareReferralView(
                    viewModel: VerticalShareReferralViewModel(
                        code: viewModel.code,
                        delegate: viewModel
                    )
                )
            }
        }
    }
}
