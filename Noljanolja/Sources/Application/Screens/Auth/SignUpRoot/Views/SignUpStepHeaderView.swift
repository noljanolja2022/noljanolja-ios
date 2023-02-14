//
//  SignUpHeader.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import SwiftUI

// MARK: - SignUpStepHeaderView

struct SignUpStepHeaderView: View {
    @Binding var step: SignUpStep

    var body: some View {
        VStack(spacing: 0) {
            Text(step.title)
                .font(FontFamily.NotoSans.bold.swiftUIFont(size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 2)
            Text(step.description)
                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 10))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 24)
            ProgressView(value: step.index, total: CGFloat(SignUpStep.allCases.count))
                .progressViewStyle(RoundedLinearProgressViewStyle())
                .frame(height: 42)
        }
    }
}

// MARK: - SignUpStepHeaderView_Previews

struct SignUpStepHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpStepHeaderView(step: .constant(.first))
    }
}
