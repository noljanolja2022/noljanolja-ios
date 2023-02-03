//
//  MainView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

// MARK: - MainView

struct MainView: View {
    @State var selectedIndex = 0

    var body: some View {
        VStack(spacing: 0) {
            if selectedIndex == 2 {
                List {
                    ForEach(1...100, id: \.self) {
                        Text("\($0)")
                    }
                }
            } else {
                Text("\(selectedIndex)")
                    .font(Font.system(size: 46))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(0)
            }
            TabItemsView(
                items: [
                    TabItem(image: "list.dash"),
                    TabItem(image: "house"),
                    TabItem(
                        image: "play.fill",
                        offset: CGSize(width: 0, height: -20),
                        backgroundColor: .orange
                    ),
                    TabItem(image: "bag"),
                    TabItem(image: "person")
                ],
                selectedIndex: $selectedIndex
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
