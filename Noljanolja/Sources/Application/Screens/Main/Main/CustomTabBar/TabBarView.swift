//
//  TabBar.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

// MARK: - TabBarView

struct TabBarView: View {
    // MARK: Dependencies

    private let items: [TabBarItem]
    @Binding private var selectionItem: TabBarItem
    private let action: (TabBarItem) -> Void

    private let selectedItemForegroundColor: Color
    private let itemForegroundColor: Color

    // MARK: Private

    private let highlightItemSize: CGFloat = 68
    private let itemSize: CGFloat = 28
    private let height: CGFloat = 56

    init(selectionItem: Binding<TabBarItem>,
         items: [TabBarItem],
         action: @escaping (TabBarItem) -> Void,
         selectedItemForegroundColor: Color = Color.orange,
         itemForegroundColor: Color = Color.black) {
        self._selectionItem = selectionItem
        self.items = items
        self.action = action
        self.selectedItemForegroundColor = selectedItemForegroundColor
        self.itemForegroundColor = itemForegroundColor
    }

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            content
        }
        .frame(height: height)
    }

    private var content: some View {
        ZStack {
            HStack(alignment: .center, spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    Button(
                        action: { action(item) },
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
                        selectionItem == item ? selectedItemForegroundColor : itemForegroundColor
                    )
                }
            }
            .background(Color.clear)

            Button(
                action: { action(.content) },
                label: {
                    Image(uiImage: TabBarItem.content.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: highlightItemSize, height: highlightItemSize)
                }
            )
            .offset(y: -height / 2)
            .foregroundColor(
                selectionItem == .content ? selectedItemForegroundColor : itemForegroundColor
            )
        }
        .frame(height: height)
    }

    private var background: some View {
        GeometryReader { geometry in
            Path { path in
                let centerX = geometry.size.width / 2
                let curveSize = highlightItemSize / 2
                let smallCurveSize: CGFloat = 20
                let padding: CGFloat = 8

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
