//
//  CardComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct CardComponent: View {
    
    // MARK: – PROPERTIES
    let mars: Card
    
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
                    + Text(String(mars.rover.name))
                        .fontWeight(.bold)
                        .foregroundColor(.layerOne)
                    
                    Text("Camera: ")
                        .foregroundColor(.layerTwo)
                    + Text(mars.camera.full_name)
                        .fontWeight(.bold)
                        .foregroundColor(.layerOne)
                    
                    Text("Date: ")
                        .foregroundColor(.layerTwo)
                    + Text(mars.earth_date)
                        .fontWeight(.bold)
                        .foregroundColor(.layerOne)
                } //: VSTACK
                Spacer()
                
                AsyncImageView(imageUrl: mars.img_src)
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
