//  UOKioskApp.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/30/22.
//

import SwiftUI
import FirebaseCore
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()

      // FIXME: AVFoundation causing error logging: AddInstanceForFactory: No factory registered for id <CFUUID 0x600000238d40> F8BB1C28-BAE8-11D6-9C31-00039315CD46
      // https://stackoverflow.com/questions/58360765/swift-5-1-error-plugin-addinstanceforfactory-no-factory-registered-for-id-c
//      do {
//          try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
//      } catch {
//          print("Failed to set audio session category. With error: \(error.localizedDescription)")
//      }
      return true
  }
}

@main
struct UOKioskApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var injector = Injector()
    @StateObject var themeService = ThemeService()

    var body: some Scene {
        WindowGroup {
            TabMenuView()
                .environmentObject(injector)
                .environmentObject(themeService)
        }
    }
}
