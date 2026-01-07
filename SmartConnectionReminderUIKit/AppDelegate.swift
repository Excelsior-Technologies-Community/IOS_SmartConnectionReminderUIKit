//
//  AppDelegate.swift
//  SmartConnectionReminderUIKit
//
//  Created by Noman belim on 06/01/26.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notificationDelegate = NotificationDelegate()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        NotificationManager.shared.requestPermission()
        UNUserNotificationCenter.current().delegate = notificationDelegate

        return true
    }
}

