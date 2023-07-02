//
//  ChatItemActionType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/04/2023.
//

import Foundation
import SwiftUI

enum ChatItemActionType {
    case openURL(String)
    case openImageDetail(URL?)
    case reaction(GeometryProxy?, Message)
}
