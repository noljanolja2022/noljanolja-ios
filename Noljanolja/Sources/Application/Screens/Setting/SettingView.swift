//
//  SettingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import SwiftUI

// MARK: - SettingView

struct SettingView<ViewModel: SettingViewModel>: View {
    // MARK: Dependencies
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        buildBodyView()
    }
    
    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Setting")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }
    }
    
    private func buildContentView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    SettingItemView(
                        title: "Exchange account management",
                        content: {
                            ImageAssets.icArrowRight.swiftUIImage
                                .frame(width: 16, height: 16)
                                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        }
                    )
                    SettingItemView(
                        title: "Name",
                        content: {
                            HStack(spacing: 12) {
                                Text(viewModel.name)
                                    .font(.system(size: 16, weight: .bold))
                                
                                ImageAssets.icEdit.swiftUIImage
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                            }
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        },
                        action: {
                            viewModel.navigationType = .updateCurrentUser
                        }
                    )
                    SettingItemView(
                        title: "Phone number",
                        content: {
                            Text(viewModel.phoneNumber)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        }
                    )
                }
                .padding(16)
                
                Divider()
                    .frame(height: 1)
                    .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                
                VStack(spacing: 0) {
                    SettingItemView(
                        title: "App push notification",
                        content: {
                            Toggle("", isOn: .constant(true))
                        }
                    )
                }
                .padding(16)
                
                Divider()
                    .frame(height: 1)
                    .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                
                VStack(spacing: 0) {
                    SettingItemView(title: "Clear cache data")
                    SettingItemView(title: "Open source license")
                }
                .padding(16)
                
                Divider()
                    .frame(height: 1)
                    .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                
                VStack(spacing: 0) {
                    SettingItemView(title: "FAQ")
                    SettingItemView(title: "Current version \(viewModel.appVersion)")
                }
                .padding(16)
            }
        }
    }
    
    private func buildNavigationLinks() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: {
                buildNavigationDestinationView($0)
            },
            label: {
                EmptyView()
            }
        )
    }
    
    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<SettingNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .updateCurrentUser:
            UpdateCurrentUserView(
                viewModel: UpdateCurrentUserViewModel()
            )
        }
    }
}

// MARK: - SettingView_Previews

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(
            viewModel: SettingViewModel()
        )
    }
}
