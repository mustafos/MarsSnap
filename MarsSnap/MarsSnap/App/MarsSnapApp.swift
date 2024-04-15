//
//  MarsSnapApp.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI

#if canImport(UIKit)
@available(iOS 14.0, *)
@main
struct MarsSnapApp: App {
    @State private var selectedRoverFilter = "perseverance" // Initialize selectedRoverFilter here
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .colorScheme(.light)
        }
    }
}
#else
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

@UIApplicationMain
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: ContentView().colorScheme(.light))
        self.window = window
        window.makeKeyAndVisible()
    }
}
#endif
