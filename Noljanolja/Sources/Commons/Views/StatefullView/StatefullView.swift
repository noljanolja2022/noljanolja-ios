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
        ZStack {
            let isNotEmpty = !(isEmpty() ?? true)
            if isNotEmpty {
                content
            } else {
                switch state {
                case .content:
                    if isNotEmpty {
                        content
                    } else {
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
