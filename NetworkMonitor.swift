//
//  NetworkMonitor.swift
//  SmartConnectionReminderUIKit
//
//  Created by Noman belim on 06/01/26.
//

import Foundation
import Foundation
import SystemConfiguration.CaptiveNetwork

import UserNotifications
import Network
import Foundation

final class NetworkMonitor: ObservableObject {

    @Published var isOnWiFi = false

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isOnWiFi = path.usesInterfaceType(.wifi)
            }
        }
        monitor.start(queue: queue)
    }
}
final class WiFiHelper {

    static func currentSSID() -> String? {
        guard
            let interfaces = CNCopySupportedInterfaces() as? [String]
        else { return nil }

        for interface in interfaces {
            if let info = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? {
                return info[kCNNetworkInfoKeySSID as String] as? String
            }
        }
        return nil
    }
}
