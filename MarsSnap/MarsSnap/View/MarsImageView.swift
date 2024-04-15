//
//  MarsImageView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2024.
//

import SwiftUI

struct MarsImageView: View {
    
    // MARK: – PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    let mars: Mars
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.layerOne
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                
                // Center the image on the screen
                let xOffset = (screenWidth - (marsImageWidth * scale)) / 2
                let yOffset = (screenHeight - (marsImageHeight * scale)) / 2
                
                // MARS IMAGE
                AsyncImageView(imageUrl: mars.imgSrc)
                    .scaledToFit()
                    .frame(width: marsImageWidth * scale, height: marsImageHeight * scale)
                    .offset(x: xOffset, y: yOffset)
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            scale = lastScale * value.magnitude
                        }
                        .onEnded { value in
                            lastScale = scale
                        }
                    )
            }
        } //: ZSTACK
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button {
            withAnimation {
                feedback.impactOccurred()
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Image("close-circle")
                .frame(width: 44, height: 44)
        })
    }
    
    // Constants for the original image dimensions
    let marsImageWidth: CGFloat = 400 // Update with the actual width of your image
    let marsImageHeight: CGFloat = 300 // Update with the actual height of your image
}
