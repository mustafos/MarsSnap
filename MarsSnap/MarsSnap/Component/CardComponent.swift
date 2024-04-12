//
//  CardComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI

struct CardComponent: View {
    
    // MARK: – PROPERTIES
    var rover: String
    var camera: String
    var date: String
    var photo: String
    
    // MARK: – BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(.white)
            
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rover:")
                            .foregroundColor(.layerTwo)
                            .fontWeight(.regular)
                        + Text(rover)
                            .fontWeight(.bold)
                            .foregroundColor(.layerOne)
                        
                        Text("Camera: ")
                            .foregroundColor(.layerTwo)
                        + Text(camera)
                            .fontWeight(.bold)
                            .foregroundColor(.layerOne)
                        
                        Text("Date: ")
                            .foregroundColor(.layerTwo)
                        + Text(date)
                            .fontWeight(.bold)
                            .foregroundColor(.layerOne)
                    } //: VSTACK
                    
                    Image(photo)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                } //: HSTACK
                .padding(.vertical, 10)
        } //: ZSTACK
        .frame(height: 150)
        .clipped()
        .shadow(radius: 10)
        .padding(.top, 20)
    }
}

#Preview {
    CardComponent(rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019", photo: "photo")
}
