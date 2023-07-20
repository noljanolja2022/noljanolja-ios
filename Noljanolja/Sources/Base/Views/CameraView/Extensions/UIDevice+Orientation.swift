//
//  UIDeviceOrientation+AVCaptureVideoOrientation.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/07/2023.
//

import AVKit
import Foundation
import SwiftUI

extension UIDevice {
    var captureVideoOrientation: AVCaptureVideoOrientation {
        switch orientation {
        case .portrait, .faceUp, .faceDown, .unknown: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        @unknown default: return .portrait
        }
    }
}
