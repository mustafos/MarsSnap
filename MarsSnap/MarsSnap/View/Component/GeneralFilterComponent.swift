//
//  GeneralFilterComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 13.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct GeneralFilterComponent: View {
    
    // MARK: – PROPERTIES
    @StateObject var networkManager = MarsPhotoManager.shared
    var isFilterCamera: Bool = true
    @State private var selectedRover: Rovers?
    @State private var selectedCamera = [Cameras]()
    @State private var cameraName: String = ""
    
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
                        ForEach(selectedCamera, id: \.self) { camera in
                            Text(camera.full_name)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.bottom)
                } else {
                    Picker("Choose the rover", selection: $selectedRover) {
                        ForEach(Rovers.allCases, id: \.self) { rover in
                            Text(rover.rawValue)
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
                    if isFilterCamera {
                        positiveButtonAction?(cameraName.capitalized)
                    } else {
                        positiveButtonAction?(selectedRover?.rawValue ?? "All")
                    }
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

enum Rovers: String, CaseIterable {
    case curiosity = "Curiosity"
    case opportunity = "Opportunity"
    case spirit = "Spirit"
}
