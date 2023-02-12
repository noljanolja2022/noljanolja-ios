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

    /// The accent color when the tab is not selected
    let accentColor: Color

    /// The accent color when the tab is selected
    let selectedAccentColor: Color

    /// The tab color when the tab is not selected
    let backgroundColor: Color

    /// The tab color when the tab is  selected
    let selectedBackgroundColor: Color

    // MARK: init

    public init(selection: Binding<Int>,
                tabs: [String],
                font: Font = Font.system(size: 16),
                accentColor: Color = Color.black,
                selectedAccentColor: Color = Color.white,
                backgroundColor: Color = Color.gray,
                selectedBackgroundColor: Color = Color.black) {
        self._selection = selection
        self.tabs = tabs
        self.font = font
        self.accentColor = accentColor
        self.selectedAccentColor = selectedAccentColor
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
    }

    // MARK: View Construction

    public var body: some View {
        assert(tabs.count > 1, "Must have at least 2 tabs")

        return HStack(spacing: 0) {
            ForEach(self.tabs, id: \.self) { tab in
                ZStack {
                    Button(
                        action: {
                            self.selection = self.tabs.firstIndex(of: tab) ?? 0
                        },
                        label: {
                            Text(tab)
                                .font(self.font)
                                .frame(maxHeight: .infinity)
                                .padding(.horizontal, 24)
                        }
                    )
                    .foregroundColor(
                        tabs[selection] == tab ? self.selectedAccentColor : self.accentColor
                    )
                    .background(
                        tabs[selection] == tab ? self.selectedBackgroundColor : self.backgroundColor
                    )
                }
            }
        }
        .frame(height: 42)
        .cornerRadius(8)
    }
}

// MARK: - TabLayout_Previews

struct TabLayout_Previews: PreviewProvider {
    @State private static var selection = 0

    static var previews: some View {
        TabLayout(
            selection: $selection,
            tabs: ["Tab 0", "Tab 1", "Tab 2", "Tab 3"]
        )
    }
}
