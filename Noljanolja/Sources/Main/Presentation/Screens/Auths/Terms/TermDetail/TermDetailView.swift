//
//  TermDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/04/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - TermDetailView

struct TermDetailView<ViewModel: TermDetailViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    var termType: TermItemType

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        VStack(spacing: 8) {
            buildHeaderView()
            buildContentView()
        }
        .background(
            ColorAssets.neutralLight.swiftUIColor
                .ignoresSafeArea()
                .overlay {
                    ColorAssets.primaryGreen200.swiftUIColor
                        .ignoresSafeArea(edges: .top)
                }
        )
    }

    @ViewBuilder
    private func buildHeaderView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    ImageAssets.icClose.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .frame(width: 24, height: 24)
                }
            )

            Text(L10n.tosTitle)
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(L10n.tosWelcome)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            Text(termType.title)
                .font(.system(size: 14, weight: .bold))
                .frame(height: 44)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 32)
            ScrollView {
                Text("""
                In the hills of North Gando, however, I see winter as one of the girls. It seems like loneliness and longing and pride that has passed. One of the buried cars has a name like this and the name of Maria. I have an exotic night on top of my desk one by one. Loneliness and foreign land fell, my mother, and love in one. In one, I see the stars, and the grave inside is mine. That's why it's named so much now in North Gando. Now, the baby star, Francis star, seems to be on the desk. I threw away the name that came out, and the people who came down like a horse blooming. My loneliness, my mother, and my worries are all because of Hale.

                Look at the name of the horse in one of the deer, sleep, and one baby. Francis of the genus fell and is still on top. The name and above, also sleeps in the heart, I am a rabbit, hill Maria mother, there is. That's why I call it one of my own. There is a night in the baby's chest. Why is it easy, rabbit, and name, name, and two. For a hill desk, look engraved. It's because of the loneliness that mourns over Maria's autumn and now the starlight is shining. Wrote the stars to worm, there is no one who cries tomorrow. It is the reason for the loneliness and loneliness of the buried star neighbor.

                It's a beautiful thing that is engraved asurahi shui. Loneliness and Poetry and Hale People's dirt, roe deer, children's stars seem far away. heal the wounds Is there no one anywhere? it's beautiful outside Loneliness and Poetry and Hale People's dirt, roe deer, children's stars seem far away. heal the wounds Is there no one anywhere? Is there no one anywhere?
                """)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .padding(.horizontal, 16)
        }
        .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
        .cornerRadius([.topLeading, .topTrailing], 40)
    }
}

// MARK: - TermDetailView_Previews

struct TermDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TermDetailView(
            viewModel: TermDetailViewModel(),
            termType: .marketingInfo
        )
    }
}
