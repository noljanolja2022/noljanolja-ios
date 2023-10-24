//
//  WalletMoneyView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/10/2023.
//

import SwiftUI

// MARK: - WalletMoneyViewDataModel

struct WalletMoneyViewDataModel {
    let title: String
    let titleColorName: String
    let changeString: String?
    let changeColorName: String
    let iconName: String
    let valueString: String
    let valueColorName: String
    let backgroundImageName: String
    let padding: CGFloat
}

// MARK: - WalletMoneyView

struct WalletMoneyView: View {
    let model: WalletMoneyViewDataModel
    
    var body: some View {
        buildBodyView()
    }
    
    private func buildBodyView() -> some View {
        buildMainView()
            .background {
                Image(model.backgroundImageName)
                    .resizable()
                    .scaledToFill()
            }
            .cornerRadius(16)
    }
    
    private func buildMainView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.title)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .foregroundColor(Color(model.titleColorName))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let changeString = model.changeString {
                HStack(spacing: 4) {
                    ImageAssets.icChange.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text(changeString)
                        .dynamicFont(.systemFont(ofSize: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .foregroundColor(Color(model.changeColorName))
            }
            
            HStack(spacing: 4) {
                Image(model.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                Text(model.valueString)
                    .dynamicFont(.systemFont(ofSize: 28, weight: .bold))
                    .foregroundColor(Color(model.valueColorName))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(model.padding)
    }
}
