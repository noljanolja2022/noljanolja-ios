//
//  MainView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

// MARK: - MainView

struct MainView: View {
    @State var selection = 0

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selection) {
                ProfileView()
                    .tag(0)
                List {
                    ForEach(1...100, id: \.self) {
                        Text("\($0)")
                    }
                }
                .tag(1)
                Text("\(selection)")
                    .tag(2)
                Text("\(selection)")
                    .tag(3)
                Text("\(selection)")
                    .tag(4)
            }
            TabBar(
                selection: $selection,
                items: [
                    TabBarItem(image: "list.dash"),
                    TabBarItem(image: "house"),
                    TabBarItem(
                        image: "play.fill",
                        offset: CGSize(width: 0, height: -20),
                        backgroundColor: .orange
                    ),
                    TabBarItem(image: "bag"),
                    TabBarItem(image: "person")
                ]
            )
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
