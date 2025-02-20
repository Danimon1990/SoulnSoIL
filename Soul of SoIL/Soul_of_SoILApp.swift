//
//  Soul_of_SoILApp.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/15/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
@main
struct Soul_of_SoILApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


      var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
          }
        }
      }
    }
