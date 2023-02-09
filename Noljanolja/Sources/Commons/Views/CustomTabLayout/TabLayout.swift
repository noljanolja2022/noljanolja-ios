//
//  TabLayout.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//

import SwiftUI

// MARK: - TabLayout

public struct TabLayout: View {
    // MARK: Required Properties

    /// Binding the selection index which will  re-render the consuming view
    @Binding var selection: Int

    /// The title of the tabs
    let tabs: [String]

    // MARK: View Customization Properties

    /// The font of the tab title
    let font: Font

    /// The selection bar sliding animation type
    let animation: Animation

    /// The accent color when the tab is selected
    let activeAccentColor: Color

    /// The accent color when the tab is not selected
    let inactiveAccentColor: Color

    /// The color of the selection bar
    let selectionBarColor: Color

    /// The tab color when the tab is not selected
    let inactiveTabColor: Color

    /// The tab color when the tab is  selected
    let activeTabColor: Color

    /// The height of the selection bar
    let selectionBarHeight: CGFloat

    /// The selection bar background color
    let selectionBarBackgroundColor: Color

    /// The height of the selection bar background
    let selectionBarBackgroundHeight: CGFloat

    // MARK: init

    public init(selection: Binding<Int>,
                tabs: [String],
                font: Font = .body,
                animation: Animation = .spring(),
                activeAccentColor: Color = .blue,
                inactiveAccentColor: Color = Color.black.opacity(0.4),
                selectionBarColor: Color = .blue,
                inactiveTabColor: Color = .clear,
                activeTabColor: Color = .clear,
                selectionBarHeight: CGFloat = 2,
                selectionBarBackgroundColor: Color = Color.gray.opacity(0.2),
                selectionBarBackgroundHeight: CGFloat = 1) {
        self._selection = selection
        self.tabs = tabs
        self.font = font
        self.animation = animation
        self.activeAccentColor = activeAccentColor
        self.inactiveAccentColor = inactiveAccentColor
        self.selectionBarColor = selectionBarColor
        self.inactiveTabColor = inactiveTabColor
        self.activeTabColor = activeTabColor
        self.selectionBarHeight = selectionBarHeight
        self.selectionBarBackgroundColor = selectionBarBackgroundColor
        self.selectionBarBackgroundHeight = selectionBarBackgroundHeight
    }

    // MARK: View Construction

    public var body: some View {
        assert(tabs.count > 1, "Must have at least 2 tabs")

        return VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(self.tabs, id: \.self) { tab in
                    Button(action: {
                        self.selection = self.tabs.firstIndex(of: tab) ?? 0
                    }) {
                        HStack {
                            Spacer()
                            Text(tab).font(self.font)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 16)
                    .accentColor(
                        self.isSelected(tabIdentifier: tab)
                            ? self.activeAccentColor
                            : self.inactiveAccentColor)
                    .background(
                        self.isSelected(tabIdentifier: tab)
                            ? self.activeTabColor
                            : self.inactiveTabColor)
                }
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(self.selectionBarColor)
                        .frame(width: self.tabWidth(from: geometry.size.width), height: self.selectionBarHeight, alignment: .leading)
                        .offset(x: self.selectionBarXOffset(from: geometry.size.width), y: 0)
                        .animation(self.animation)
                    Rectangle()
                        .fill(self.selectionBarBackgroundColor)
                        .frame(width: geometry.size.width, height: self.selectionBarBackgroundHeight, alignment: .leading)
                }.fixedSize(horizontal: false, vertical: true)
            }.fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Private Helper

    private func isSelected(tabIdentifier: String) -> Bool {
        tabs[selection] == tabIdentifier
    }

    private func selectionBarXOffset(from totalWidth: CGFloat) -> CGFloat {
        tabWidth(from: totalWidth) * CGFloat(selection)
    }

    private func tabWidth(from totalWidth: CGFloat) -> CGFloat {
        totalWidth / CGFloat(tabs.count)
    }
}

// MARK: - TabLayout_Previews

struct TabLayout_Previews: PreviewProvider {
    @State private static var selection = 0

    static var previews: some View {
        TabLayout(selection: $selection, tabs: ["Tab 0", "Tab 1", "Tab 2", "Tab 3"])
    }
}
