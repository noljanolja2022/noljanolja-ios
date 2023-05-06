//
//  VideoProgressEventType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/05/2023.
//

import Foundation

enum VideoProgressEventType: String, Encodable {
    case play = "PLAY"
    case pause = "PAUSE"
    case finish = "FINISH"
}
