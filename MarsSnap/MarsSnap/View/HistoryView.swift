//
//  HistoryView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2024.
//

import SwiftUI

struct HistoryView: View {
    
    // MARK: – PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @State private var isEmptyHustory: Bool = false
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
        VStack {
            HeaderView()
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer()
                    if isEmptyHustory {
                        ZStack {
                            Image("empty")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 193, height: 186)
                                .padding(.top, 200)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ForEach(animals, id: \.self) { mars in
                            NavigationLink(destination: MarsImageView(image: mars.photo)) {
                                CardComponent(isFilterCard: true, rover: mars.rover, camera: mars.camera, date: mars.date, photo: mars.photo)
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
                    }
                } //: SCROLL
            } //: ZSTACK
            .background(Color.backgroundOne)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        } //: VSTACK
        .navigationBarBackButtonHidden(true)
        .background(Color.accentColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        ZStack {
            HStack {
                Button {
                    feedback.impactOccurred()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("back")
                        .frame(width: 44, height: 44)
                }
                Spacer()
            } //: HSTACK
            Text("History")
                .font(.largeTitle)
                .fontWeight(.bold)
        } //: ZSTACK
        .padding(.top, 50)
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color.accentColor)
        .edgesIgnoringSafeArea(.all)
    }
}
