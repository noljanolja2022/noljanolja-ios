//
//  TabItems.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

struct TabItems<Item>: View where Item: View {
    private let items: [Item]
    @Binding private var selected: Int

    init(items: [Item], selected: Binding<Int>) {
        self.items = items
        self._selected = selected
    }

    var body: some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(items.indices, id: \.self) { index in
                    Button(
                        action: { selected = index },
                        label: { items[index] }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: 54)
        }
        .padding(.bottom, UIApplication.shared.rootKeyWindow?.safeAreaInsets.bottom ?? .zero)
        .background(Color.green)
    }
}
