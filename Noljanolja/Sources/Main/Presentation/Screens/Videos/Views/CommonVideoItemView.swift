//
//  CommonVideoItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - CommonVideoItemViewModelable

protocol CommonVideoItemViewModelable: Equatable {
    var thumbnail: String? { get }
    var point: Int { get }
    var title: String? { get }
    var category: String? { get }
    var description: String { get }
    var currentProgressMs: Int { get }
    var durationMs: Int { get }
}

// MARK: - CommonVideoItemViewModel

struct CommonVideoItemViewModel: CommonVideoItemViewModelable {
    let thumbnail: String?
    let point: Int
    let title: String?
    let category: String?
    let description: String
    let currentProgressMs: Int
    let durationMs: Int

    init(_ model: Video) {
        self.thumbnail = model.thumbnail
        self.point = model.totalPoints
        self.title = model.title
        self.category = model.category?.title
        self.description = [
            model.channel?.title,
            "\(model.viewCount.relativeFormatted()) Views",
            model.publishedAt?.relative()
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
        .joined(separator: " • ")
        self.currentProgressMs = model.currentProgressMs
        self.durationMs = model.durationMs
    }
}

// MARK: - UncompleteVideoItemViewModel

struct UncompleteVideoItemViewModel: CommonVideoItemViewModelable {
    let thumbnail: String?
    let point: Int
    let title: String?
    let category: String?
    let description: String
    let currentProgressMs: Int
    let durationMs: Int

    init(_ model: Video) {
        self.thumbnail = model.thumbnail
        self.point = model.totalPoints - model.earnedPoints
        self.title = model.title
        self.category = model.category?.title
        self.description = [
            model.channel?.title,
            "\(model.viewCount.relativeFormatted()) \(L10n.videoDetailViews)",
            model.publishedAt?.relative()
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
        .joined(separator: " • ")
        self.currentProgressMs = model.currentProgressMs
        self.durationMs = model.durationMs
    }
}

// MARK: - CommonVideoItemElementType

enum CommonVideoItemElementType: Equatable {
    case actionButton
    case category
    case description
    case progress
}

// MARK: - CommonVideoItemView

struct CommonVideoItemView: View {
    var model: any CommonVideoItemViewModelable
    var elementTypes: [CommonVideoItemElementType] = [.actionButton, .category, .description, .progress]
    var action: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 5) {
            buildImageView()
            buildDetailView()
        }
    }

    private func buildImageView() -> some View {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(9 / 5, contentMode: .fill)
    }

    private func buildDetailView() -> some View {
        VStack(spacing: 8) {
            if model.point != 0 {
                buildPointView()
            }
            VStack(spacing: 8) {
                buildVideoInfoView()
                buildProgressView()
            }
            .padding(.horizontal, 16)
        }
    }
}

extension CommonVideoItemView {
    private func buildPointView() -> some View {
        Text("\(model.point.signFormatted()) Points after watching")
            .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(8)
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .background(ColorAssets.secondaryYellow300.swiftUIColor)
    }

    private func buildVideoInfoView() -> some View {
        HStack(alignment: .top, spacing: 8) {
            buildVideoTitleInfoView()
            buildVideoActionView()
        }
    }

    private func buildVideoTitleInfoView() -> some View {
        VStack(spacing: 4) {
            Text(model.title ?? "")
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            if elementTypes.contains(.category),
               let category = model.category, !category.isEmpty {
                Text("#\(category)")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .dynamicFont(.systemFont(ofSize: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)
            }

            if elementTypes.contains(.description) {
                Text(model.description)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .dynamicFont(.systemFont(ofSize: 10))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
        }
    }

    @ViewBuilder
    private func buildVideoActionView() -> some View {
        if elementTypes.contains(.actionButton) {
            Button(
                action: {
                    action?()
                },
                label: {
                    ImageAssets.icMore.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            )
        }
    }

    @ViewBuilder
    private func buildProgressView() -> some View {
        if elementTypes.contains(.progress) {
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Text("Complete state: \(Int(Double(model.currentProgressMs * 100) / Double(model.durationMs)))%")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(String(format: "%.1f min/ %.1f min", Double(model.currentProgressMs) / (60 * 1000), Double(model.durationMs) / (60 * 1000)))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .dynamicFont(.systemFont(ofSize: 14))
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                LinearProgressView(
                    progress: CGFloat(model.currentProgressMs) / CGFloat(model.durationMs),
                    forcegroundColor: ColorAssets.primaryGreen100.swiftUIColor,
                    backgroundColor: ColorAssets.neutralGrey.swiftUIColor
                )
                .frame(height: 6)
            }
        }
    }
}
