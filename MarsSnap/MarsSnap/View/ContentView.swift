//
//  ContentView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Detail View")) {
                    Text("Go to Detail View")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
