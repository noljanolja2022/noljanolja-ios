//
//  NotificationAppDelegate.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import FirebaseMessaging
import Foundation
import UIKit

// MARK: - NotificationAppDelegate

final class NotificationAppDelegate: NSObject, UIApplicationDelegate {
    private let notificationUseCases: NotificationUseCases

    init(notificationUseCases: NotificationUseCases = NotificationUseCasesImpl.default) {
        self.notificationUseCases = notificationUseCases
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Register for remote notifications
        UNUserNotificationCenter.current().delegate = self

        if UserDefaults.standard.isNotification {
            application.registerForRemoteNotifications()
        } else {
            application.unregisterForRemoteNotifications()
        }

        // Set the messaging delegate
        Messaging.messaging().delegate = self

        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error", error)
    }
}

// MARK: UNUserNotificationCenterDelegate

extension NotificationAppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let _ = notification.request.content.userInfo
        return [.badge, .sound, .list, .banner]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationHelper.shared.handleNotification(userInfo)
        completionHandler()
    }
}

// MARK: MessagingDelegate

extension NotificationAppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        notificationUseCases.sendPushToken(token: fcmToken)
        DispatchQueue.main.async {
            Messaging.messaging().subscribe(toTopic: "/topics/promote-video") { error in
                let error = error.flatMap { "Error: \($0.localizedDescription)" } ?? ""
                print("Subscribe to topic \"topics/promote-video\". \(error)")
            }
        }
    }
}
