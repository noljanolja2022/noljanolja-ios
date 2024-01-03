//
//  MessageReactionsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/06/2023.
//

import SwiftUI

struct MessageReactionsView: View {
    var model: MessageReactionsModel?
    var quickTapAction: ((ReactIcon) -> Void)?
    var quickLongPressAction: ((GeometryProxy?) -> Void)?

    var body: some View {
        buildBodyView()
    }
    
    @ViewBuilder
    private func buildBodyView() -> some View {
        if let model {
            buildContentView(model)
        }
    }
        
    private func buildContentView(_ model: MessageReactionsModel) -> some View {
        HStack(spacing: 8) {
            buildQuickView(model)
            buildSummaryView(model)
        }
        .frame(alignment: .trailing)
        .padding(.horizontal, 8)
        .environment(\.layoutDirection, model.layoutDirection)
    }
    
    @ViewBuilder
    private func buildQuickView(_ model: MessageReactionsModel) -> some View {
        if let quick = model.quick {
            GeometryReader { geometry in
                Text(quick.code ?? "")
                    .dynamicFont(.systemFont(ofSize: 11))
                    .saturation(model.quickSaturation)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                    .cornerRadius(12)
                    .border(ColorAssets.neutralLight.swiftUIColor, width: 2, cornerRadius: 12)
                    .onTapGesture {
                        quickTapAction?(quick)
                    }
                    .onLongPressGesture {
                        quickLongPressAction?(geometry)
                    }
            }
            .frame(width: 34, height: 24)
        }
    }

    @ViewBuilder
    private func buildSummaryView(_ model: MessageReactionsModel) -> some View {
        if !model.recents.isEmpty {
            HStack(spacing: 4) {
                HStack(spacing: 0) {
                    ForEach(model.recents.indices, id: \.self) { index in
                        let model = model.recents[index]
                        Text(model.code ?? "")
                            .dynamicFont(.systemFont(ofSize: 10))
                    }
                }
                Text(String(model.count))
                    .dynamicFont(.systemFont(ofSize: 10))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            .frame(height: 20)
            .padding(.horizontal, 6)
            .background(Color(model.backgroundColorName))
            .cornerRadius(10)
            .border(ColorAssets.neutralLight.swiftUIColor, width: 2, cornerRadius: 10)
            .environment(\.layoutDirection, .leftToRight)
        }
    }
}
