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
            ZStack {
                VStack {
                    Header()
                    List {
                        ForEach(destinations, id: \.self) { destination in
                            NavigationLink(destination: Text(destination)) {
                                Text("Go to \(destination)")
                            }
                        }
                    }
                }
                
                HistoryButtonComponent {
                    print("History")
                }
            }
            .background(Color.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    let destinations = ["Detail View 1", "Detail View 2", "Detail View 3"]
    
    @ViewBuilder
    private func Header() -> some View {
        VStack {
            Text("")
            Text("")
            Text("")
            HStack {
                VStack(alignment: .leading) {
                    Text("mars.camera".uppercased())
                        .font(.system(size: 34, weight: .bold))
                    Text("June 6, 2019")
                }
                Spacer()
                Button(action: {}, label: {
                    Image("calendar")
                })
            }
            HStack {
                Button {} label: {
                    HStack {
                        Image("cpu")
                        Text("All")
                    }
                    .padding(5)
                }
                .background(Color.white)
                
                Button {} label: {
                    HStack {
                        Image("camera")
                        Text("All")
                    }
                    .padding(5)
                }
                .background(Color.white)
                
                Spacer()
                
                Button {} label: {
                    HStack {
                        Image(systemName: "plus")
                    }
                    .padding(5)
                }
                .background(Color.white)
            }
        }
        .padding()
        .background(Color.accentOne)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
