//
//  StatefullHeaderView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/03/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - StatefullFooterViewState

enum StatefullFooterViewState {
    case normal
    case loading
    case error
    case noMoreData

    var isLoadEnabled: Bool {
        switch self {
        case .normal, .error: return true
        case .loading, .noMoreData: return false
        }
    }
}

// MARK: - StatefullFooterView

struct StatefullFooterView<LoadingView, ErrorView, NoMoreDataView>: View where LoadingView: View, ErrorView: View, NoMoreDataView: View {
    @Binding var state: StatefullFooterViewState
    var loadingView: LoadingView
    var errorView: ErrorView
    var noMoreDataView: NoMoreDataView

    init(state: Binding<StatefullFooterViewState>,
         loadingView: LoadingView = LoadingFooterView(),
         errorView: ErrorView = ErrorFooterView(),
         noMoreDataView: NoMoreDataView = NoMoreDataFooterView()) {
        self._state = state
        self.loadingView = loadingView
        self.errorView = errorView
        self.noMoreDataView = noMoreDataView
    }

    var body: some View {
        ZStack {
            switch state {
            case .normal: EmptyView()
            case .loading: loadingView
            case .error: errorView
            case .noMoreData: noMoreDataView
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}

// MARK: - StatefullFooterView_Previews

struct StatefullFooterView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingFooterView()
    }
}

// MARK: - LoadingFooterView

struct LoadingFooterView: View {
    var body: some View {
        ActivityIndicator()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - LoadingFooterView_Previews

struct LoadingFooterView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingFooterView()
    }
}

// MARK: - ErrorFooterView

struct ErrorFooterView: View {
    var action: (() -> Void)?

    var body: some View {
        Button(
            action: { action?() },
            label: {
                VStack(spacing: 4) {
                    Text(L10n.commonErrorDescription)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Text("Try again")
                        .font(.system(size: 14, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        )
    }
}

// MARK: - ErrorFooterView_Previews

struct ErrorFooterView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorFooterView()
    }
}

// MARK: - NoMoreDataFooterView

struct NoMoreDataFooterView: View {
    var body: some View {
        Text("No more data")
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - NoMoreDataFooterView_Previews

struct NoMoreDataFooterView_Previews: PreviewProvider {
    static var previews: some View {
        NoMoreDataFooterView()
    }
}
