//
//  MainView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

// MARK: - MainView

struct MainView: View {
    @State var selected = 0

    var body: some View {
        VStack {
            Text("\(selected)")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            TabItems(
                items: [
                    TabItem(systemName: "list.dash"),
                    TabItem(systemName: "house"),
                    TabItem(systemName: "play.fill"),
                    TabItem(systemName: "bag"),
                    TabItem(systemName: "person")
                ],
                selected: $selected
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
