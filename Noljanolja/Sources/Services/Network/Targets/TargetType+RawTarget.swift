//
//  TargetType+RawTarget.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Moya

extension TargetType {
    var rawTarget: TargetType {
        if let multiTarget = self as? MultiTarget {
            return multiTarget.target
        }
        return self
    }
}
