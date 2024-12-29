//
//  MarsSnapApp.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

@main
struct MarsSnapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let store = Store(reducer: appReducer, state: AppState(), middlewares: [photoMiddleware()])
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(store)
                .colorScheme(.light)
            //            ContentView()
            //                .colorScheme(.light)
        }
    }
}

import UIKit
import SDWebImage

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Когда приложение получает предупреждение о нехватке памяти
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        SDImageCache.shared.clearMemory()
        print("Memory cache cleared automatically due to memory warning")
    }
    
    // Когда приложение теряет активность (например, при скрытии)
    func applicationWillResignActive(_ application: UIApplication) {
        clearDiskCache()
    }
    
    // Когда приложение уходит в фоновый режим
    func applicationDidEnterBackground(_ application: UIApplication) {
        clearDiskCache()
    }
    
    // Метод для очистки дискового кэша
    private func clearDiskCache() {
        SDImageCache.shared.clearDisk {
            print("Disk cache cleared")
        }
    }
}
