//
//  FilterCardComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 14.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct FilterCardComponent: View {
    
    // MARK: – PROPERTIES
    let history: Card
    
    // MARK: – BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(.backgroundOne)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.accentOne)
                            .frame(height: 1)
                        Text("Filters")
                            .font(.custom("SF Pro", size: 22))
                            .fontWeight(.bold)
                    }
                    Text("Rover: ")
                        .foregroundColor(.layerTwo)
                        .fontWeight(.regular)
                    + Text(history.rover.name)
                        .fontWeight(.bold)
                        .foregroundColor(.layerOne)
                    
                    Text("Camera: ")
                        .foregroundColor(.layerTwo)
                    + Text(history.camera.full_name)
                        .fontWeight(.bold)
                        .foregroundColor(.layerOne)
                    
                    Text("Date: ")
                        .foregroundColor(.layerTwo)
                    + Text("history.selectedEarthDate")
                        .fontWeight(.bold)
                        .foregroundColor(.layerOne)
                } //: VSTACK
                Spacer()
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
