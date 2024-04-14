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
    
    // MARK: – BODY
    var body: some View {
        ZStack {
            Color.layerOne
                .edgesIgnoringSafeArea(.all)
            // MARS IMAGE
            AsyncImageView(imageUrl: mars.imageUrl!)
                .scaledToFit()
                .frame(maxWidth: .infinity)
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
}
