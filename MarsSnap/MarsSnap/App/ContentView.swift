//
//  ContentView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: – PROPERTIES
    let animals = [
        MarsData(rover: "Spirit", camera: "Navigation Camera", date: "April 18, 2005", photo: "photo"),
        MarsData(rover: "Curiosity", camera: "ChemCam", date: "August 29, 2012", photo: "photo"),
        MarsData(rover: "Perseverance", camera: "Sherloc", date: "March 2, 2021", photo: "photo"),
        MarsData(rover: "Opportunity", camera: "Microscopic Imager", date: "December 7, 2004", photo: "photo"),
        MarsData(rover: "Spirit", camera: "Panoramic Camera", date: "March 10, 2005", photo: "photo"),
        MarsData(rover: "Curiosity", camera: "Rover Environmental Monitoring Station", date: "November 26, 2013", photo: "photo"),
        MarsData(rover: "Perseverance", camera: "Mars Hand Lens Imager", date: "April 1, 2021", photo: "photo"),
        MarsData(rover: "Opportunity", camera: "Miniature Thermal Emission Spectrometer", date: "June 17, 2004", photo: "photo"),
        MarsData(rover: "Spirit", camera: "Mini-TES", date: "April 28, 2005", photo: "photo"),
        MarsData(rover: "Curiosity", camera: "Mars Descent Imager", date: "August 6, 2012", photo: "photo"),
    ]
    
    // MARK: – BODY
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    VStack {
//                        LottieView(loopMode: .loop)
//                            .scaleEffect(0.4)
                        HeaderView()
                        ZStack {
                            ScrollView(.vertical, showsIndicators: false) {
                                Spacer()
                                ForEach(animals, id: \.self) { mars in
                                    NavigationLink(destination: MarsImageView(image: mars.photo)) {
                                        CardComponent(rover: mars.rover, camera: mars.camera, date: mars.date, photo: mars.photo)
                                    } //: LINK
                                } //: LOOP
                                HStack {
                                    Spacer()
                                    Text("Copyright © 2024 Mustafa Bekirov. \nAll rights reserved.")
                                        .font(.footnote)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                } //: HSTACK
                                .padding(10)
                                .animation(.easeIn)
                            } //: SCROLL
                        } //: ZSTACK
                        .background(Color.backgroundOne)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        
                    } //: VSTACK
                    .background(Color.accentColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                } //: GROUP
                .navigationBarHidden(true)
                
                HistoryButton()
                
            } //: ZSTACK
        } //: NAVIGATION
    }
    
    // MARK: – VIEW BUILDER
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("mars.camera".uppercased())
                        .font(.system(size: 34, weight: .bold))
                    Text("June 6, 2019")
                }
                Spacer()
                Button(action: {
                    feedback.impactOccurred()
                }, label: {
                    Image("calendar")
                })
            } //: HSTACK
            HStack {
                Button {
                    feedback.impactOccurred()
                } label: {
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
            } //: HSTACK
        } //: VSTACK
        .padding(.top, 50)
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color.accentColor)
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func HistoryButton() -> some View {
        NavigationLink {
            HistoryView()
        } label: {
            Circle()
                .frame(width: 70, height: 70)
                .foregroundColor(.accentColor)
                .shadow (radius: 5)
                .overlay(Image("archive"))
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.trailing, 20)
        .padding(.bottom, 10)
    }
}

// MARK: – PREVIEW
#Preview {
    ContentView()
}
