import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {

  // =====================================
  // 🚀 APP LAUNCH
  // =====================================
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // 🔹 Firebase
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }

    debugPrint("📦 Bundle Identifier: \(Bundle.main.bundleIdentifier ?? "N/A")")

    // 🔹 Notification permissions
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self

      let options: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: options
      ) { granted, error in
        debugPrint("🔐 Push permission granted: \(granted)")
        if let error = error {
          debugPrint("❌ Permission error: \(error)")
        }
      }
    }

    // 🔹 Register for APNs
    application.registerForRemoteNotifications()

    // 🔹 Firebase Messaging delegate
    Messaging.messaging().delegate = self

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // =====================================
  // 🍎 APNs TOKEN
  // =====================================
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    debugPrint("✅ APNs token recibido:")
    debugPrint(token)
  }

  // =====================================
  // 🔑 FCM TOKEN
  // =====================================
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    guard let token = fcmToken else { return }
    debugPrint("✅ FCM token generado:")
    debugPrint(token)
  }

  // =====================================
  // 📩 PUSH RECIBIDA (BACKGROUND / DATA)
  // =====================================
  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    debugPrint("📩 PUSH RECIBIDA EN iOS (NATIVO)")
    debugPrint("📦 userInfo:")
    debugPrint(userInfo)
    completionHandler(.newData)
  }

  // =====================================
  // 📩 PUSH RECIBIDA EN FOREGROUND
  // =====================================
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    debugPrint("📩 PUSH RECIBIDA EN FOREGROUND (iOS)")
    debugPrint("📦 userInfo:")
    debugPrint(notification.request.content.userInfo)

    completionHandler([.alert, .sound, .badge])
  }

  // =====================================
  // 👉 PUSH ABIERTA POR EL USUARIO
  // =====================================
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    debugPrint("📩 PUSH ABIERTA POR EL USUARIO")
    debugPrint("📦 userInfo:")
    debugPrint(response.notification.request.content.userInfo)

    super.userNotificationCenter(
      center,
      didReceive: response,
      withCompletionHandler: completionHandler
        )
      }
}
