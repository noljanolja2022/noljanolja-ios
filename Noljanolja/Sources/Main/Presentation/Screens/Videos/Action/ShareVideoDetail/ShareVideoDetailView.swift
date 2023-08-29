//
//  ShareVideoDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 29/07/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: ShareVideoDetailView

struct ShareVideoDetailView<ViewModel: ShareVideoDetailViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) {
                Alert($0) { _ in }
            }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 12) {
            buildNavigationBarView()
            buildUserView(viewModel.user)
            buildVideoView(viewModel.video)
            buildActionView()
        }
        .frame(maxWidth: .infinity)
    }

    private func buildNavigationBarView() -> some View {
        NavigationBarView(
            centerView: {
                Text(L10n.commonShare)
                    .dynamicFont(.systemFont(ofSize: 14))
            }
        )
        .frame(height: 50)
    }

    private func buildUserView(_ model: User) -> some View {
        VStack(spacing: 8) {
            WebImage(
                url: URL(string: model.avatar),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 40 * 3, height: 40 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 40, height: 40)
            .background(ColorAssets.neutralGrey.swiftUIColor)
            .cornerRadius(14)

            Text(model.name ?? "")
                .multilineTextAlignment(.center)
                .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private func buildVideoView(_ model: Video) -> some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                WebImage(
                    url: URL(string: model.thumbnail),
                    context: [
                        .imageTransformer: SDImageResizingTransformer(
                            size: CGSize(
                                width: geometry.size.width * 3,
                                height: geometry.size.height * 3
                            ),
                            scaleMode: .aspectFill
                        )
                    ]
                )
                .resizable()
                .indicator(.activity)
                .frame(maxWidth: .infinity)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 5 / 9)

            Text(L10n.getPointAfterWatching(model.totalPoints.formatted()))
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(8)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(ColorAssets.secondaryYellow300.swiftUIColor)

            VStack(spacing: 2) {
                Text(model.title ?? "")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                if let category = model.category?.title, !category.isEmpty {
                    Text("#\(category)")
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .dynamicFont(.systemFont(ofSize: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.blue)
                }

                let description = [
                    model.channel?.title,
                    "\(model.viewCount.relativeFormatted()) \(L10n.videoDetailViews)",
                    model.publishedAt?.relative()
                ]
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .joined(separator: " • ")
                Text(description)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .dynamicFont(.systemFont(ofSize: 10))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
            .padding(16)
        }
    }

    private func buildActionView() -> some View {
        Button(
            L10n.commonShare.uppercased(),
            action: {
                viewModel.action.send()
            }
        )
        .buttonStyle(PrimaryButtonStyle())
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .padding(.horizontal, 16)
    }
}
