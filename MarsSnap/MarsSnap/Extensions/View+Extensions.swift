//
//  View+Extensions.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 06.01.2025.
//  Copyright © 2025 Mustafa Bekirov. All rights reserved.

import SwiftUI

extension View {
    func embedInNavigationView() -> some View {
        NavigationView { self }
            .navigationViewStyle(.stack)
    }
}
