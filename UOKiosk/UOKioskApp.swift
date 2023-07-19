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

      do {
          try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [/*.mixWithOthers, .allowAirPlay*/])
      } catch {
          print("Failed to set audio session category.")
      }
      return true
  }
}

@main
struct UOKioskApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var injector: Injector = Injector()

    var body: some Scene {
        WindowGroup {
            TabMenuView()
                .environmentObject(injector)
        }
    }
}
