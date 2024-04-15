//
//  GeneralFilterComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 13.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct GeneralFilterComponent: View {
    
    // MARK: – PROPERTIES
    @ObservedObject var viewModel = MarsPhotosViewModel()
    var isFilterCamera: Bool = true
//    let rover: Rover
//    let camera: Camera
    @State private var cameraName = String()
    @State private var roverName = String()
    
    @Binding var selectedFilter: String
    var positiveButtonAction: ((String) -> ())? = nil
    var negativeButtonAction: (() -> ())? = {}
    
    // MARK: – BODY
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            Spacer()
            VStack {
                
                
                ForEach(viewModel.photos, id: \.id) { photo in
                    NavigationLink(destination: MarsImageView(marsPhoto: photo, manager: self.viewModel)) {
                        CardComponent(mars: photo)
                    } //: LINK
                } //: LOOP
                
                
                
                HeaderView()
                if isFilterCamera {
                    Picker("Choose the camera", selection: $cameraName) {
//                        ForEach(Camera.allCases) { camera in
//                            Text(camera.rawValue.capitalized)
//                                .tag(camera)
//                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.bottom)
                } else {
                    Picker("Choose the rover", selection: $roverName) {
//                        ForEach(Rover.allCases) { rover in
//                            Text(rover.rawValue.capitalized)
//                                .tag(rover)
//                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.bottom)
                }
            } //: VSTACK
            .frame(maxWidth: .infinity, maxHeight: 306)
            .background(Color.backgroundOne)
            .cornerRadius(50)
        } //: ZSTACK
        .edgesIgnoringSafeArea(.all)
        .zIndex(2)
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Button {
                withAnimation {
                    Constants.feedback.impactOccurred()
                    negativeButtonAction?()
                }
            } label: {
                Image("close")
                    .frame(width: 44, height: 44)
            }
            Spacer()
            
            Text(isFilterCamera ? "Camera" : "Rover")
                .font(.system(size: 22, weight: .bold))
            
            Spacer()
            Button {
                withAnimation {
                    Constants.feedback.impactOccurred()
//                    positiveButtonAction?(isFilterCamera ? cameraName.rawValue : roverName.rawValue)
                }
            } label: {
                Image("correct")
                    .frame(width: 44, height: 44)
            }
        }
        .padding([.top, .horizontal], 20)
    }
}

extension GeneralFilterComponent {
    func onPositiveButtonTap(_ positiveButtonAction: ((String) -> ())?) -> Self {
        var alert = self
        alert.positiveButtonAction = positiveButtonAction
        return alert
    }
    
    func onNegativeButtonTap(_ negativeButtonAction: (() -> ())?) -> Self {
        var alert = self
        alert.negativeButtonAction = negativeButtonAction
        return alert
    }
}
