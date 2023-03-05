//
//  SettingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import SwiftUI

// MARK: - SettingView

struct SettingView<ViewModel: SettingViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = SettingViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Setting")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                        .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                }
            }
    }

    var content: some View {
        ScrollView {
            VStack(spacing: 0) {
                Section {
                    Text("Account")
                        .font(FontFamily.NotoSans.medium.swiftUIFont(fixedSize: 16))
                        .frame(height: 64)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Button(
                        action: { viewModel.send(.signOut) },
                        label: {
                            ProfileItemView(
                                imageName: "rectangle.portrait.and.arrow.right",
                                title: "Logout"
                            )
                        }
                    )

                    ProfileItemView(
                        imageName: "trash.fill",
                        title: "Delete Account"
                    )
                }

                Spacer().frame(height: 24)

                Section {
                    Text("Coustomer Care")
                        .font(FontFamily.NotoSans.medium.swiftUIFont(fixedSize: 16))
                        .frame(height: 52)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ProfileItemView(
                        imageName: "rectangle.portrait.and.arrow.right",
                        title: "Notice Board"
                    )

                    ProfileItemView(
                        imageName: "trash.fill",
                        title: "FAQ"
                    )
                }
            }
            .padding(16)
        }
    }
}

// MARK: - SettingView_Previews

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
