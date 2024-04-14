//
//  CardComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI

struct CardComponent: View {
    
    // MARK: – PROPERTIES
    let mars: Mars
    
    // MARK: – BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(.backgroundOne)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Rover: ")
                        .foregroundColor(.layerTwo)
                        .fontWeight(.regular)
                    + Text(mars.rover)
                        .fontWeight(.bold)
                        .foregroundColor(.layerOne)
                    
                    Text("Camera: ")
                        .foregroundColor(.layerTwo)
                    + Text(mars.camera)
                        .fontWeight(.bold)
                        .foregroundColor(.layerOne)
                    
                    Text("Date: ")
                        .foregroundColor(.layerTwo)
                    + Text(mars.date)
                        .fontWeight(.bold)
                        .foregroundColor(.layerOne)
                } //: VSTACK
                Spacer()
                AsyncImageView(imageUrl: mars.imageUrl!)
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
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
