//
//  Log+.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import FirebaseCrashlytics
import Foundation
import SwiftyBeaver

let logger: SwiftyBeaver.Type = {
    let logSwiftyBeaver = SwiftyBeaver.self

    let console = ConsoleDestination()
    console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $T $L: $M"
    logSwiftyBeaver.addDestination(console)

    let firebaseCrashlyticsCustomLog = FirebaseCrashlyticsCustomLogDestination()
    firebaseCrashlyticsCustomLog.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $T $L: $M"
    logSwiftyBeaver.addDestination(firebaseCrashlyticsCustomLog)

    return logSwiftyBeaver
}()

// MARK: - FirebaseCrashlyticsCustomLogDestination

final class FirebaseCrashlyticsCustomLogDestination: BaseDestination {
    override func send(_ level: SwiftyBeaver.Level, msg: String, thread: String, file: String, function: String, line: Int, context: Any? = nil) -> String? {
        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)
        if let formattedString {
            Crashlytics.crashlytics().log(formattedString)
        }
        return formattedString
    }
}
