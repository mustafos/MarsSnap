//
//  MarsImageView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct MarsImageView: View {
    @Environment(\.presentationMode) var presentationMode
    let photo: Photo
    let cameraName: String

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            AsyncImageView(imageUrl: photo.imageURL, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(scale)
                .gesture(magnify)
                .onTapGesture(count: 2) {
                    withAnimation(.spring()) {
                        scale = 1
                        lastScale = 1
                    }
                }

            VStack {
                HStack {
                    Button {
                        Haptics.tap()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("close-circle")
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Close")
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text(photo.roverTitle)
                        .font(.headline)
                    Text(cameraName)
                    Text("\(MarsCalendar.display(photo.earthDate))  ·  Sol \(photo.sol)")
                    Text("NASA/JPL-Caltech")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color.black.opacity(0.45))
            }
        }
        .navigationBarHidden(true)
    }

    private var magnify: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = min(max(lastScale * value, 1), 5)
            }
            .onEnded { _ in
                lastScale = scale
            }
    }
}
