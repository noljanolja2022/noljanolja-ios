//
//  TabBar.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

struct TabBarView: View {
    private let items: [TabBarItem]
    @Binding private var selection: TabBarItem

    private let highlightItemSize: CGFloat = 84
    private let itemSize: CGFloat = 36
    private let selectedItemForegroundColor = Color.orange
    private let itemForegroundColor = Color.black

    init(selection: Binding<TabBarItem>, items: [TabBarItem]) {
        self._selection = selection
        self.items = items
    }

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            content
        }
        .background(Color.clear)
        .frame(height: 44)
    }

    private var content: some View {
        ZStack {
            Button(
                action: { selection = .wallet },
                label: {
                    Image(uiImage: TabBarItem.wallet.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: highlightItemSize, height: highlightItemSize)
                }
            )
            .offset(y: -highlightItemSize / 2)

            HStack(alignment: .center, spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    Button(
                        action: { selection = item },
                        label: {
                            if !item.isHighlight {
                                Image(uiImage: item.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: itemSize, height: itemSize)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ZStack {}
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    )
                    .foregroundColor(
                        selection == item ? selectedItemForegroundColor : itemForegroundColor
                    )
                }
            }
            .background(Color.clear)
        }
        .background(Color.clear)
    }

    private var background: some View {
        GeometryReader { geometry in
            Path { path in
                let centerX = geometry.size.width / 2
                let curveSize = highlightItemSize / 2
                let smallCurveSize: CGFloat = 24
                let padding: CGFloat = 4

                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: centerX - curveSize - smallCurveSize - padding, y: 0))

                path.addCurve(
                    to: CGPoint(x: centerX, y: curveSize + padding),
                    control1: CGPoint(x: centerX - curveSize - padding, y: 0),
                    control2: CGPoint(x: centerX - curveSize - padding, y: curveSize + padding)
                )

                path.addCurve(
                    to: CGPoint(x: centerX + curveSize + smallCurveSize + padding, y: 0),
                    control1: CGPoint(x: centerX + curveSize + padding, y: curveSize + padding),
                    control2: CGPoint(x: centerX + curveSize + padding, y: 0)
                )

                path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                path.addLine(to: CGPoint(x: 0, y: geometry.size.height))

                path.closeSubpath()
            }
            .fill(Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(radius: 4)
    }
}
