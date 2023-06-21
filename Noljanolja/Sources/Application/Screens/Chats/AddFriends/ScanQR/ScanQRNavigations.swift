//
//  ScanQRNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/06/2023.
//

import Foundation

// MARK: - ScanQRFullScreenCoverType

enum ScanQRFullScreenCoverType: Equatable {
    case imagePicker
}

// MARK: - ScanQRNavigationType

enum ScanQRNavigationType {
    case result([User])
}
