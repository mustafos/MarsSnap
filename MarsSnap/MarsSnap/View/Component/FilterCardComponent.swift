//
//  FilterCardComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 14.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct FilterCardComponent: View {
    let rover: String
    let camera: String
    let date: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.backgroundOne)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.accentOne)
                        .frame(height: 1)
                    Text("Filters")
                        .font(.system(size: 22, weight: .bold))
                }
                labeled("Rover: ", rover)
                labeled("Camera: ", camera)
                labeled("Date: ", date)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }

    private func labeled(_ title: String, _ value: String) -> Text {
        Text(title)
            .foregroundColor(.layerTwo)
        + Text(value)
            .fontWeight(.bold)
            .foregroundColor(.layerOne)
    }
}
