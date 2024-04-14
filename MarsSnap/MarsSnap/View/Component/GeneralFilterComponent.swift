//
//  GeneralFilterComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 13.04.2024.
//

import SwiftUI

struct GeneralFilterComponent: View {
    
    // MARK: – PROPERTIES
    var isFilterCamera: Bool = true
    
    @State private var cameraName = Camera.all
    @State private var roverName = Rover.all
    
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
                HeaderView()
                if isFilterCamera {
                    Picker("Choose the camera", selection: $cameraName) {
                        ForEach(Camera.allCases) { camera in
                            Text(camera.rawValue.capitalized)
                                .tag(camera)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.bottom)
                } else {
                    Picker("Choose the rover", selection: $roverName) {
                        ForEach(Rover.allCases) { rover in
                            Text(rover.rawValue.capitalized)
                                .tag(rover)
                        }
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
                    feedback.impactOccurred()
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
                    feedback.impactOccurred()
                    positiveButtonAction?(isFilterCamera ? cameraName.rawValue : roverName.rawValue)
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
