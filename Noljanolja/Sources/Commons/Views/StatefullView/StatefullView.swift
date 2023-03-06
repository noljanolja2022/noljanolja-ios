//
//  StatefullView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import SwiftUI

// MARK: - ViewState

enum ViewState<Content, Failure> {
    case content(Content)
    case error(Failure)
    case loading
}

extension ViewState {
    var isContent: Bool {
        switch self {
        case .content: return true
        case .error, .loading: return false
        }
    }
}

// MARK: - StatefullView.State

extension StatefullView {
    enum State {
        case content
        case error
        case loading
    }
}

// MARK: - StatefullView

struct StatefullView<ContentView, LoadingView, ErrorView>: View
    where ContentView: View, LoadingView: View, ErrorView: View {
    @Binding var state: State
    @Binding var hasContent: Bool
    var contentView: ContentView
    var loadingView: LoadingView
    var errorView: ErrorView

    var body: some View {
        ZStack {
            if hasContent {
                contentView
            } else {
                switch state {
                case .content: contentView
                case .loading: loadingView
                case .error: errorView
                }
            }
        }
    }
}

// MARK: - StatefullView_Previews

struct StatefullView_Previews: PreviewProvider {
    static var previews: some View {
        StatefullView(
            state: .constant(.loading),
            hasContent: .constant(false),
            contentView: Text("Content"),
            loadingView: Text("Loading"),
            errorView: Text("Error")
        )
    }
}
