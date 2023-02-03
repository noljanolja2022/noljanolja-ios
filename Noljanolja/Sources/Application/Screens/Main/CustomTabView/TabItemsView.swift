//
//  TabItems.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

struct TabItemsView: View {
    private let items: [TabItem]
    @Binding private var selectedIndex: Int

    init(items: [TabItem], selectedIndex: Binding<Int>) {
        self.items = items
        self._selectedIndex = selectedIndex
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        let size = min(geometry.size.width / 5, geometry.size.height)
                        ZStack {
                            Circle()
                                .fill(item.backgroundColor)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            Button(
                                action: { selectedIndex = index },
                                label: {
                                    Image(systemName: item.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: size - 30, height: size - 30)
                                }
                            )
                            .frame(width: geometry.size.width / 5, height: geometry.size.height)
                        }
                        .offset(item.offset)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .frame(height: 54)
        }
        .padding(.bottom, UIApplication.shared.rootKeyWindow?.safeAreaInsets.bottom ?? .zero)
        .background(Color.green)
    }
}
