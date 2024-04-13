//
//  CardComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI

struct CardComponent: View {
    
    // MARK: – PROPERTIES
    //    let model: Mars
    var isFilterCard: Bool = false
    var rover: String
    var camera: String
    var date: String
    var photo: String
    
    // MARK: – BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(.backgroundOne)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if isFilterCard {
                        HStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.accentOne)
                                .frame(height: 1)
                            Text("Filters")
                                .font(.custom("SF Pro", size: 22))
                                .fontWeight(.bold)
                        }
                    }
                    Text("Rover: ")
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
                Spacer()
                if !isFilterCard {
                    Image(photo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )
                }
            } //: HSTACK
            .padding(10)
        } //: ZSTACK
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .padding(.horizontal, 20)
        .clipped()
        .shadow(radius: 10)
    }
}

// MARK: – PREVIEW
#Preview {
    CardComponent(rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019", photo: "photo")
}
