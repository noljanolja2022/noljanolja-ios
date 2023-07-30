//
//  BottomSheet.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/04/2023.
//

import SwiftUI
import SwiftUIX
import UIKit

// MARK: - BottomSheet

struct BottomSheet<Content: View>: View {
    @Environment(\.presentationMode) private var presentationMode

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack(alignment: .bottom) {
            buildBackgroundView()
            buildContentView()
        }
        .introspectViewController {
            $0.view.backgroundColor = .clear
        }
    }

    private func buildBackgroundView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.4))
            .edgesIgnoringSafeArea(.top)
            .onPress {
                withoutAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        content
            .background(.white)
            .cornerRadius([.topLeading, .topTrailing], 24)
    }
}
