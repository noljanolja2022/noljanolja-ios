//
//  BannersView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/06/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - BannersView

struct BannersView<ViewModel: BannersViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .introspectViewController {
                $0.view.backgroundColor = .clear
            }
    }

    private func buildContentView() -> some View {
        ZStack {
            buildMainView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea())
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }

    private func buildMainView() -> some View {
        ZStack(alignment: .topTrailing) {
            TabView {
                ForEach(viewModel.banners.indices, id: \.self) { index in
                    buildBannerItemView(viewModel.banners[index])
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .fixedSize(horizontal: false, vertical: true)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(16)
            .onTapGesture {}

            Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    ImageAssets.icClose.swiftUIImage
                        .resizable()
                        .padding(6)
                        .frame(width: 20, height: 20)
                        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                        .background(ColorAssets.neutralGrey.swiftUIColor)
                        .cornerRadius(10)
                }
            )
            .padding(8)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
    }

    private func buildBannerItemView(_ model: Banner) -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        WebImage(
                            url: URL(string: model.image),
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
                        .scaledToFill()
                    }
                    .clipped()
            }

            switch model.action {
            case .none, .empty, .share, .checkin:
                EmptyView()
            case .link:
                Button(
                    model.action?.title.uppercased() ?? "",
                    action: {}
                )
                .buttonStyle(PrimaryButtonStyle())
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - BannersView_Previews

struct BannersView_Previews: PreviewProvider {
    static var previews: some View {
        BannersView(viewModel: BannersViewModel(banners: []))
    }
}
