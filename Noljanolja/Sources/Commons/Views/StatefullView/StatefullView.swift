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

//// MARK: - SubStateViewType
//
// protocol SubStateViewType: View {
//    associatedtype Value
// }
//
//// MARK: - SubStateView
//
// struct SubStateView<Value, Body>: SubStateViewType where Body: View {
//    @Binding var value: Value?
//    var content: (Value) -> Body
//
//    var body: some View {
//        IfLet($value) { value in
//            content(value.wrappedValue)
//        }
//    }
// }
//
// extension SubStateView {
//    static func empty(_ value: Binding<Void?>) -> SubStateView<Void, EmptyView> {
//        SubStateView<Void, EmptyView>(value: value) { _ in EmptyView() }
//    }
//
//    static func empty(_ value: Binding<Bool?>) -> SubStateView<Bool, EmptyView> {
//        SubStateView<Bool, EmptyView>(value: value) { _ in EmptyView() }
//    }
// }
//
// extension View {
//    func statefull(loading: SubStateView<some Any, some Any> = .empty(.constant(())),
//                   empty: SubStateView<Bool, some Any> = .empty(.constant(false)),
//                   error: SubStateView<some Any, some Any> = .empty(.constant(()))) -> some View {
//        modifier(
//            StatefullModifier(
//                loading: loading,
//                empty: empty,
//                error: error
//            )
//        )
//    }
// }
//
//// MARK: - StatefullModifier
//
// struct StatefullModifier<LoadingValue, ErrorValue, LoadingView, EmptyView, ErrorView>: ViewModifier where LoadingView: View, EmptyView: View, ErrorView: View {
//    var loading: SubStateView<LoadingValue, LoadingView>
//    var empty: SubStateView<Bool, EmptyView>
//    var error: SubStateView<ErrorValue, ErrorView>
//
//    func body(content: Content) -> some View {
//        ZStack {
//            if !(empty.value ?? false) {
//                content
//            } else if loading.value != nil {
//                loading
//            } else if error.value != nil {
//                error
//            } else {
//                empty
//            }
//        }
//    }
// }
