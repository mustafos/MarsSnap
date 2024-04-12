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
            VStack(alignment: .center, spacing: 20) {
                // MARS IMAGE
                Image(image)
                    .resizable()
                    .scaledToFit()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        feedback.impactOccurred()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("close-circle")
                    }
                }
            }
        } //: ZSTACK
    }
}

// MARK: – PREVIEW
#Preview {
    NavigationView {
        MarsImageView(image: "photo")
    }
}
