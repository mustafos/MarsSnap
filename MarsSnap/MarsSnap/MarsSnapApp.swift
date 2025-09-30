//
//  MarsSnapApp.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI
import UIKit
import SDWebImage

@main
struct MarsSnapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var store = Store(
        reducer: appReducer,
        state: AppState(),
        middlewares: [photoMiddleware()]
    )

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(store)
                .colorScheme(.light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        SDImageCache.shared.clearMemory()
    }
}
