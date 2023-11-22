//
//  UpdateCurrentUserInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/11/2023.
//

import Foundation
import SwiftUI

struct UpdateCurrentUserInputView<Content: View>: View {
    let content: () -> Content
    let title: String
    let description: String
    let isEditing: Bool
    let errorMessage: String?
    
    var body: some View {
        let tintColor: Color = {
            if errorMessage != nil {
                return ColorAssets.systemRed100.swiftUIColor
            }
            if isEditing {
                return ColorAssets.primaryGreen200.swiftUIColor
            }
            return ColorAssets.neutralDarkGrey.swiftUIColor
        }()
        
        let descriptionString: String = errorMessage ?? description
        
        let descriptionColor: Color = {
            if errorMessage != nil {
                return ColorAssets.systemRed100.swiftUIColor
            }
            return ColorAssets.neutralDeepGrey.swiftUIColor
        }()
        
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .dynamicFont(.systemFont(ofSize: 12))
                    .frame(alignment: .leading)
                    .padding(4)
                    .background(ColorAssets.neutralLight.swiftUIColor)
                    .foregroundColor(tintColor)
                    
                content()
            }
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .padding(.horizontal, 16)
            .background {
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(tintColor, width: 1, cornerRadius: 4)
                    .padding(.top, 12)
            }

            Text(descriptionString)
                .dynamicFont(.systemFont(ofSize: 12))
                .foregroundColor(descriptionColor)
                .padding(.horizontal, 16)
        }
    }
}
