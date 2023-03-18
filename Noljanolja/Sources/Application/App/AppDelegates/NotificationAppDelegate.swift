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

final class NotificationAppDelegate: NSObject, AppDelegateProtocol {
    private let notificationService: NotificationServiceType

    init(notificationService: NotificationServiceType = NotificationService.default) {
        self.notificationService = notificationService
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Register for remote notifications
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()

        // Set the messaging delegate
        Messaging.messaging().delegate = self

        return true
    }

    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: UNUserNotificationCenterDelegate

extension NotificationAppDelegate: UNUserNotificationCenterDelegate {}

// MARK: MessagingDelegate

extension NotificationAppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        notificationService.sendPushToken(token: fcmToken)
    }
}
