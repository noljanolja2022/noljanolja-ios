//
//  BottomSheet.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/04/2023.
//

import SwiftUI
import UIKit

// MARK: - BottomSheet

struct BottomSheet<Content: View>: View {
    @Environment(\.presentationMode) private var presentationMode

    @State var isContentHidden = true

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()

        UIView.setAnimationsEnabled(false)
    }

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack(alignment: .bottom) {
            buildBackgroundView()
            buildContentView()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                isContentHidden = false
            }
        }
        .onDisappear {
            UIView.setAnimationsEnabled(true)
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
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        if !isContentHidden {
            content
                .background(.white)
                .cornerRadius([.topLeading, .topTrailing], 24)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .move(edge: .top)
                    )
                )
        }
    }
}
