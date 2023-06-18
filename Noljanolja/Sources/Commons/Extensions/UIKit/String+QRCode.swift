//
//  String+QRCode.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/06/2023.
//

import Foundation
import UIKit

extension String {
    func qrCodeImage() -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        guard let data = data(using: .utf8) else {
            return nil
        }
        filter.message = data
        guard let outputImage = filter.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
