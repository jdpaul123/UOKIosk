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
