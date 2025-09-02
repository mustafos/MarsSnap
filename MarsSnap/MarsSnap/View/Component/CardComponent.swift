//
//  CardComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct CardComponent: View {
    let photo: Photo
    let cameraName: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.backgroundOne)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    labeled("Rover: ", photo.roverTitle)
                    labeled("Camera: ", cameraName)
                    labeled("Date: ", MarsCalendar.display(photo.earthDate))
                }
                Spacer(minLength: 8)
                AsyncImageView(imageUrl: photo.imageURL)
                    .frame(width: 130, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }

    private func labeled(_ title: String, _ value: String) -> Text {
        Text(title)
            .foregroundColor(.layerTwo)
            .fontWeight(.regular)
        + Text(value)
            .fontWeight(.bold)
            .foregroundColor(.layerOne)
    }
}
