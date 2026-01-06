# 📡 Smart Connection Reminder (UIKit)

> A practical UIKit-based iOS demo app that reminds users to carry important items (wallet, keys, bag, etc.) when they disconnect from a trusted Wi-Fi network such as home or office.

This project demonstrates real-world iOS system behavior, Apple privacy rules, and proper use of networking and notifications using UIKit.

---

## 🚀 Features

- ✅ Detects Wi-Fi connection & disconnection
- ✅ Supports multiple trusted Wi-Fi networks
- ✅ Stores different reminder items per Wi-Fi
- ✅ Automatically reloads saved items when reconnecting
- ✅ Sends local notifications on Wi-Fi disconnect
- ✅ Built using UIKit + Combine
- ✅ Apple App Store–compliant approach

---

## 🧠 How the App Works (High Level)

1. **User connects to a Wi-Fi network** (Home / Office)
2. **User selects important items** (wallet, keys, bag, etc.)
3. **User taps "Mark Current Wi-Fi as Safe"**
4. **App saves:**
   - Wi-Fi name (SSID)
   - Selected reminder items
5. **When Wi-Fi disconnects:**
   - App assumes the user is leaving
   - Sends a local notification with selected items
6. **When the same Wi-Fi reconnects:**
   - Previously selected items are auto-loaded
   - User does not need to select again

---

## 📱 Example Scenario

| Wi-Fi Name | Saved Items  | Notification |
|------------|--------------|--------------|
| nomanwifi  | Wallet, Keys | Don't forget your Wallet, Keys |
| myWifi     | Bag          | Don't forget your Bag |

---

## 🏗️ Project Architecture (UIKit)

```
SmartConnectionReminderUIKit
│
├── AppDelegate.swift
├── SceneDelegate.swift
├── ViewController.swift
│
├── NetworkMonitor.swift
├── SafeWiFiStore.swift
├── WiFiHelper.swift
├── LocationManager.swift
└── NotificationManager.swift
```

> 🔹 **Business logic files are shared with SwiftUI**  
> 🔹 **Only the UI layer is UIKit**

---

## 📂 File-Wise Explanation

### 🔹 AppDelegate.swift
- App launch entry point
- Requests notification permission
- Registers notification delegate so banners show even when app is active

**Key code:**
```swift
NotificationManager.shared.requestPermission()
UNUserNotificationCenter.current().delegate = NotificationDelegate()
```

### 🔹 SceneDelegate.swift
- Sets up the app window
- Embeds `ViewController` inside a `UINavigationController`

**Key code:**
```swift
window.rootViewController = UINavigationController(
    rootViewController: ViewController()
)
```

### 🔹 ViewController.swift

**Main UIKit UI controller that:**
- Displays current Wi-Fi name
- Shows selectable items using `UITableView`
- Provides "Mark Current Wi-Fi as Safe" button
- Observes network changes using Combine
- Triggers save and notification logic via `SafeWiFiStore`

**Key implementation:**
```swift
// Observe Wi-Fi state changes using Combine
networkMonitor.$isOnWiFi
    .receive(on: DispatchQueue.main)
    .sink { [weak self] isOnWiFi in
        if isOnWiFi {
            self?.store.onWiFiConnected()
        } else {
            self?.store.onWiFiDisconnected()
        }
    }
```

**UIKit components used:**
- `UIViewController`
- `UITableView` (for item selection)
- `UIStackView` (for layout)
- `UIButton`
- `UILabel`

### 🔹 NetworkMonitor.swift

Uses `NWPathMonitor` to detect network changes in real-time.

**Key code:**
```swift
private let monitor = NWPathMonitor()

monitor.pathUpdateHandler = { path in
    DispatchQueue.main.async {
        self.isOnWiFi = path.usesInterfaceType(.wifi)
    }
}
monitor.start(queue: queue)
```

This is the Apple-recommended API for network monitoring and publishes Wi-Fi state changes via `@Published var isOnWiFi`.

### 🔹 SafeWiFiStore.swift (Core Logic)

**The brain of the app.**

**Responsibilities:**
- Stores Wi-Fi → item mapping
- Persists data using `UserDefaults`
- Loads saved items on Wi-Fi reconnect
- Sends notification on Wi-Fi disconnect

**Key methods:**

**1. Marking a Wi-Fi as safe:**
```swift
func markCurrentWiFiSafe() {
    let ssid = WiFiHelper.currentSSID() ?? "WiFi_\(Date().timeIntervalSince1970)"
    wifiData[ssid] = Array(selectedItems)
    safeNetworks.append(ssid)
    save() // Persist to UserDefaults
}
```

**2. Handling Wi-Fi disconnect:**
```swift
func onWiFiDisconnected() {
    guard wasOnWiFi, let ssid = lastKnownSSID else { return }
    guard safeNetworks.contains(ssid) else { return }
    
    let items = wifiData[ssid] ?? []
    NotificationManager.shared.send(
        title: "🚶 You're leaving",
        body: "Don't forget your \(items.joined(separator: ", "))"
    )
}
```

**Internal storage format:**
```json
{
  "nomanwifi": ["Wallet", "Keys"],
  "myWifi": ["Bag"]
}
```

### 🔹 WiFiHelper.swift

Fetches the current Wi-Fi name (SSID) using Apple's network APIs.

**Key code:**
```swift
static func currentSSID() -> String? {
    guard let interfaces = CNCopySupportedInterfaces() as? [String] else { return nil }
    
    for interface in interfaces {
        if let info = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? {
            return info[kCNNetworkInfoKeySSID as String] as? String
        }
    }
    return nil
}
```

**⚠️ Requires:**
- Location permission
- Access Wi-Fi Information capability
- Real iPhone device (not Simulator)

### 🔹 LocationManager.swift

Requests location permission, which iOS requires to access Wi-Fi information.

**Key code:**
```swift
private let manager = CLLocationManager()

override init() {
    super.init()
    manager.delegate = self
    manager.requestWhenInUseAuthorization()
}
```

Without location permission, `currentSSID()` returns `nil`.

### 🔹 NotificationManager.swift

Handles local notification scheduling and permission requests.

**Key methods:**

**1. Request permission:**
```swift
func requestPermission() {
    UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound]) { granted, _ in
            print("🔔 Notification permission:", granted)
        }
}
```

**2. Send notification:**
```swift
func send(title: String, body: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    
    let trigger = UNTimeIntervalNotificationTrigger(
        timeInterval: 1,
        repeats: false
    )
    
    let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: content,
        trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request)
}
```

Notifications appear 1 second after Wi-Fi disconnect.

### 🔹 WiFiHelper.swift (NotificationDelegate)

Ensures notifications appear as banners even when the app is in the foreground.

**Key code:**
```swift
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
) async -> UNNotificationPresentationOptions {
    [.banner, .sound]
}
```

---

## 🔔 Notification Example

```
🚶 You're leaving
Don't forget your Wallet, Keys
```

*Only the items selected for that Wi-Fi are shown.*

---

## 🔐 Required Permissions & Capabilities

### 📌 Info.plist

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to detect Wi-Fi network name</string>
```

### 📌 Xcode → Signing & Capabilities

- ✅ Access Wi-Fi Information
- ✅ Background Modes (optional, improves reliability)

---

## ⚠️ Important Apple Limitations

> **Must Read**

- ❌ iOS Simulator cannot provide real Wi-Fi SSID
- ❌ SSID may not be available if app is force-killed
- ❌ Continuous background Wi-Fi tracking is not allowed

✅ **This app follows Apple's privacy and security rules**

---

## 🧪 Testing Guidelines

- ✔ Test on a real iPhone
- ✔ Allow Location & Notification permissions
- ✔ Keep app in foreground or background (do not force kill)

**Testing flow:**
1. Connect to Wi-Fi
2. Select items (Wallet, Keys)
3. Tap "Mark Current Wi-Fi as Safe"
4. Turn off Wi-Fi or walk away from network
5. Notification appears: "Don't forget your Wallet, Keys"

---

## 🎯 Use Cases

- Forgetting wallet or keys at home
- Leaving office without laptop bag
- Hostel / PG reminders
- Network-based automation demo
- Interview-ready system design example

---

## 🧩 Technologies Used

- **UIKit** - Traditional iOS UI framework
- **Combine** - Reactive programming for state observation
- **Network framework** - Wi-Fi monitoring via `NWPathMonitor`
- **CoreLocation** - Location permissions for SSID access
- **UserNotifications** - Local notifications
- **SystemConfiguration** - Wi-Fi SSID retrieval

---

## 📌 Why This Project Is Valuable

- Demonstrates real iOS system limitations
- Clean separation of UI and logic
- Shows proper permission handling
- Ideal for:
  - Technical interviews
  - Learning system APIs
  - Utility app demos
  - Understanding UIKit patterns

---

## 🔄 SwiftUI vs UIKit

This project is also available in **SwiftUI**. Both versions share the same business logic:

| Aspect | UIKit Version | SwiftUI Version |
|--------|---------------|-----------------|
| UI Framework | UIKit | SwiftUI |
| Business Logic | ✅ Same | ✅ Same |
| Complexity | More boilerplate | More declarative |
| Best For | Learning UIKit | Modern iOS dev |

---

## 🏁 Conclusion

Smart Connection Reminder (UIKit) is a practical example of building a Wi-Fi–aware reminder system using UIKit while respecting Apple's privacy policies. It demonstrates how to work with system frameworks, persistence, and notifications in a real-world iOS app.

The project showcases:
- Network monitoring with `NWPathMonitor`
- Wi-Fi SSID detection with proper permissions
- Data persistence with `UserDefaults`
- Local notifications with `UNUserNotificationCenter`
- Reactive UI updates with Combine
- Clean architecture separating UI from business logic

---

## 📝 License

This project is available for educational and demonstration purposes. 
