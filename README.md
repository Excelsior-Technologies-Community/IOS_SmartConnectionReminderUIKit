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

### 🔹 SceneDelegate.swift
- Sets up the app window
- Embeds `ViewController` inside a `UINavigationController`

### 🔹 ViewController.swift

**Main UIKit UI controller that:**
- Displays current Wi-Fi name
- Shows selectable items using `UITableView`
- Provides "Mark Current Wi-Fi as Safe" button
- Observes network changes using Combine
- Triggers save and notification logic via `SafeWiFiStore`

**UIKit components used:**
- `UIViewController`
- `UITableView`
- `UIStackView`
- `UIButton`
- `UILabel`

### 🔹 NetworkMonitor.swift

Uses `NWPathMonitor` to detect network changes:
- Wi-Fi connected
- Wi-Fi disconnected

```swift
path.usesInterfaceType(.wifi)
```

This is the Apple-recommended API for network monitoring.

### 🔹 SafeWiFiStore.swift (Core Logic)

**The brain of the app.**

**Responsibilities:**
- Stores Wi-Fi → item mapping
- Persists data using `UserDefaults`
- Loads saved items on Wi-Fi reconnect
- Sends notification on Wi-Fi disconnect

**Internal storage format:**
```json
{
  "nomanwifi": ["Wallet", "Keys"],
  "myWifi": ["Bag"]
}
```

### 🔹 WiFiHelper.swift

Fetches the current Wi-Fi name (SSID) using:

```swift
CNCopyCurrentNetworkInfo
```

**⚠️ Requires:**
- Location permission
- Access Wi-Fi Information capability
- Real iPhone device (not Simulator)

### 🔹 LocationManager.swift

Requests location permission, which iOS requires to access Wi-Fi information.

```swift
manager.requestWhenInUseAuthorization()
```

### 🔹 NotificationManager.swift

Handles:
- Notification permission request
- Local notification scheduling

**Uses:**
- `UNUserNotificationCenter`
- `UNNotificationRequest`
- `UNTimeIntervalNotificationTrigger`

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
- **Combine** - Reactive programming
- **Network framework** - Wi-Fi monitoring
- **CoreLocation** - Location permissions
- **UserNotifications** - Local notifications

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

---

## 📝 License

This project is available for educational and demonstration purposes.
 
