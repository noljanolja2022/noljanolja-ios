//
//  MainView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import SwiftUI

// MARK: - MainView

struct MainView<ViewModel: MainViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = MainViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        TabView {
            Text("Chat")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorAssets.background.swiftUIColor)
                .tabItem {
                    Image(systemName: "message.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Chat")
                }

            Text("Events")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorAssets.background.swiftUIColor)
                .tabItem {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Events")
                }

            Text("Content")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorAssets.background.swiftUIColor)
                .tabItem {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Content")
                }
            
            Text("Shop")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorAssets.background.swiftUIColor)
                .tabItem {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Shop")
                }

            ProfileView(
                viewModel: ProfileViewModel(
                    delegate: viewModel
                )
            )
            .tabItem {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                Text("Chat")
            }
        }
        .accentColor(Color.orange)
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
