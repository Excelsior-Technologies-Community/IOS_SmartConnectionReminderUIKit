//
//  SafeWiFiStore.swift
//  SmartConnectionReminderUIKit
//
//  Created by Noman belim on 06/01/26.
//

import Foundation

import Foundation

final class SafeLocationManager: ObservableObject {

    @Published var isSafeLocationActive = false
    @Published var selectedItems: Set<String> = []

    private var wasOnWiFi: Bool = false

    // MARK: - User marks safe place
    func markSafeLocation(currentWiFiState: Bool) {
        guard currentWiFiState else {
            print("❌ Not on Wi-Fi, cannot mark safe location")
            return
        }

        isSafeLocationActive = true
        wasOnWiFi = true

        print("✅ Safe location marked")
    }

    // MARK: - Network change handler
    func handleNetworkChange(isOnWiFi: Bool) {

        print("🔄 Network changed. wasOnWiFi:", wasOnWiFi, "isOnWiFi:", isOnWiFi)

        // REAL condition: Wi-Fi → OFF
        if wasOnWiFi && !isOnWiFi && isSafeLocationActive {
            triggerReminder()
            isSafeLocationActive = false
        }

        wasOnWiFi = isOnWiFi
    }

    private func triggerReminder() {
        guard !selectedItems.isEmpty else {
            print("⚠️ No items selected, skipping notification")
            return
        }

        let items = selectedItems.joined(separator: ", ")

        NotificationManager.shared.send(
            title: "🚶 You’re leaving",
            body: "Don’t forget your \(items)"
        )

        print("🔔 Notification sent")
    }

    func toggleItem(_ item: String) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }
}
