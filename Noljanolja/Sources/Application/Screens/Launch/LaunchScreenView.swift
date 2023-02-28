//
//  LaunchScreenView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//
//

import SwiftUI

// MARK: - LaunchScreenViewController

struct LaunchScreenViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Launch Screen", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Launch View Controller")
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

// MARK: - LaunchScreenView

struct LaunchScreenView<ViewModel: LaunchScreenViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @EnvironmentObject private var rootViewState: RootViewState

    init(viewModel: ViewModel = LaunchScreenViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        LaunchScreenViewController()
            .ignoresSafeArea()
            .onAppear {
                viewModel.loadDataTrigger.send()
            }
            .onReceive(viewModel.isLoadDataSuccessfulPublisher) {
                rootViewState.contentType = $0 ? .main : .auth
            }
    }
}

// MARK: - LaunchScreenView_Previews

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
