//
//  UIImage+QRCode.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Foundation
import UIKit

extension UIImage {
    func detectQRCode() -> [String] {
        guard let ciImage = CIImage(image: self) else { return [] }

        var options: [String: Any]
        let context = CIContext()
        options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        if ciImage.properties.keys.contains(kCGImagePropertyOrientation as String) {
            options = [CIDetectorImageOrientation: ciImage.properties[kCGImagePropertyOrientation as String] ?? 1]
        } else {
            options = [CIDetectorImageOrientation: 1]
        }

        let features = qrDetector?.features(in: ciImage, options: options) ?? []

        let result = features
            .compactMap { $0 as? CIQRCodeFeature }
            .compactMap { $0.messageString }

        return result
    }
}
