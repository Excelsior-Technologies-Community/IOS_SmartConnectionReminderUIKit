//
//  WiFiHelper.swift
//  SmartConnectionReminderUIKit
//
//  Created by Noman belim on 06/01/26.
//
import UserNotifications

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
