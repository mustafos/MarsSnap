//
//  ContentView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
    }
}

#Preview {
    ContentView()
        .environmentObject(
            Store(reducer: appReducer, state: AppState(), middlewares: [photoMiddleware()])
        )
}
