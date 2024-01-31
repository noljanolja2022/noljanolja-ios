//
//  NotificationHelper.swift
//  Noljanolja
//
//  Created by kii on 31/01/2024.
//

import Combine
import UIKit

final class NotificationHelper: ObservableObject {
    static var shared = NotificationHelper()

    let conversationSingleAction = PassthroughSubject<Int?, Never>()

    func handleNotification(_ userInfo: [AnyHashable: Any]) {
        if let conversationType = userInfo["conversationType"] as? String {
            switch conversationType {
            case "SINGLE", "GROUP":
                guard let conversationId = userInfo["conversationId"] as? String else { return }
                handleConversationSingle(conversationId)
            default:
                break
            }
        }
    }

    func handleConversationSingle(_ conversationId: String) {
        guard let conversationId = Int(conversationId) else { return }
        UserDefaults.standard.chatSingleIdNoti = conversationId
    }
}
