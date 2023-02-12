//
//  Test.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/02/2023.
//

import Foundation
import SwiftUI

// MARK: - ScreenView

struct ScreenView: View {
    @Binding private var isShowingScreen2: Bool

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")

            NavigationLink(
                destination: ResetPasswordView(isShowingResetPasswordView: $isShowingScreen2),
                isActive: $isShowingScreen2,
                label: { Text("Show screen 2") }
            )
        }
        .padding()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - ScreenView2

struct ScreenView2: View {
    @Binding var isShowingScreen2: Bool
    @State var type: AlertType? = nil
    @State var text = ""

    init(isShowingScreen2: Binding<Bool>) {
        self._isShowingScreen2 = isShowingScreen2
    }

    var body: some View {
        VStack {
            TextField("E", text: $text)
            Button("Show alert and back") {
                type = .show
            }
        }

        .alert(item: $type, content: { _ in
            Alert(
                title: Text("Alert"),
                message: Text("Message"),
                dismissButton: .default(Text("OK")) {
                    isShowingScreen2 = false
                }
            )
        })
    }
}

// MARK: - AlertType

enum AlertType: Identifiable {
    case show

    var id: String { "" }
}
