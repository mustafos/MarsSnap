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
    //    let mars: Mars
    var image: String
    
    // MARK: – BODY
    var body: some View {
        ZStack {
            Color.layerOne
                .edgesIgnoringSafeArea(.all)
            // MARS IMAGE
            Image(image)
                .resizable()
                .scaledToFit()
        } //: ZSTACK
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button {
            feedback.impactOccurred()
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("close-circle")
                .frame(width: 44, height: 44)
        })
    }
}

// MARK: – PREVIEW
#Preview {
    NavigationView {
        MarsImageView(image: "photo")
    }
}
