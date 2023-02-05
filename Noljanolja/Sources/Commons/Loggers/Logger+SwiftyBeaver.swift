//
//  Log+.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import Foundation
import SwiftyBeaver

let logger: SwiftyBeaver.Type = {
    let logSwiftyBeaver = SwiftyBeaver.self
    let console = ConsoleDestination()
    console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $T $L: $M"
    logSwiftyBeaver.addDestination(console)
    return logSwiftyBeaver
}()
