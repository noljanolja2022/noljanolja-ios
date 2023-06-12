//
//  QRScannerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/06/2023.
//

import Foundation
import SwiftUI
import SwiftUIX

struct FriendScannerView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = FriendScannerViewController

    var onReceiveQRCode: ((String) -> Void)?

    public func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = FriendScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.base = self
    }

    public class Coordinator: NSObject, FriendScannerViewControllerDelegate {
        var base: FriendScannerView

        init(base: FriendScannerView) {
            self.base = base
        }
    }

    public func makeCoordinator() -> Coordinator {
        .init(base: self)
    }
}
