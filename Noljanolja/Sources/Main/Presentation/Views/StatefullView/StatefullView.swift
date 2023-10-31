//
//  StatefullView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import SwiftUI
import SwiftUINavigation

// MARK: - ViewState

enum ViewState {
    case loading
    case content
    case error
}

extension View {
    func statefull(state: Binding<ViewState>,
                   isEmpty: @escaping () -> Bool?,
                   loading: @escaping () -> some View = { EmptyView() },
                   empty: @escaping () -> some View = { EmptyView() },
                   error: @escaping () -> some View = { EmptyView() }) -> some View {
        modifier(
            StatefullWithStateModifier(
                state: state,
                isEmpty: isEmpty,
                loading: loading,
                empty: empty,
                error: error
            )
        )
    }
}

// MARK: - StatefullWithStateModifier

struct StatefullWithStateModifier<LoadingView, EmptyView, ErrorView>: ViewModifier where LoadingView: View, EmptyView: View, ErrorView: View {
    @Binding var state: ViewState
    var isEmpty: () -> Bool?
    var loading: () -> LoadingView
    var empty: () -> EmptyView
    var error: () -> ErrorView

    func body(content: Content) -> some View {
        StatefullView(
            state: $state,
            isEmpty: isEmpty,
            content: content,
            loading: loading,
            empty: empty,
            error: error
        )
    }
}

// MARK: - StatefullView

struct StatefullView<ContentView: View, LoadingView: View, EmptyView: View, ErrorView: View>: View {
    @Binding private var state: ViewState
    private let isEmpty: () -> Bool?
    private let content: ContentView
    private let loading: () -> LoadingView
    private let empty: () -> EmptyView
    private let error: () -> ErrorView

    init(state: Binding<ViewState>,
         isEmpty: @escaping () -> Bool?,
         content: ContentView,
         loading: @escaping () -> LoadingView = { SwiftUI.EmptyView() },
         empty: @escaping () -> EmptyView = { SwiftUI.EmptyView() },
         error: @escaping () -> ErrorView = { SwiftUI.EmptyView() }) {
        self._state = state
        self.isEmpty = isEmpty
        self.content = content
        self.loading = loading
        self.empty = empty
        self.error = error
    }

    var body: some View {
        ZStack {
            content

            let isEmpty = isEmpty() ?? false
            if isEmpty {
                switch state {
                case .content:
                    if isEmpty {
                        empty()
                    }
                case .loading:
                    loading()
                case .error:
                    error()
                }
            }
        }
    }
}
