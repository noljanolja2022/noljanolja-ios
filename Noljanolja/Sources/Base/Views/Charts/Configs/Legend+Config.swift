//
//  Legend+Cònig.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/05/2023.
//

import Charts
import Foundation

// MARK: - LegendConfig

class LegendConfig: ComponentBaseConfig {}

extension Legend {
    func setConfig(_ config: LegendConfig) {
        if let enabled = config.enabled {
            self.enabled = enabled
        }
    }
}
