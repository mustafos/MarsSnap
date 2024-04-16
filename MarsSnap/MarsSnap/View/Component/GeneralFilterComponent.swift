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
    @State private var selectedRover: Rovers?
    @State private var selectedCamera: Cameras?
    
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
                    Picker("Choose the camera", selection: $selectedCamera) {
                        ForEach(Cameras.allCases, id: \.self) { camera in
                            Text(camera.fullName)
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
                        positiveButtonAction?(selectedCamera?.rawValue ?? "All")
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

enum Cameras: String, CaseIterable {
    case fhaz = "FHAZ"
    case rhaz = "RHAZ"
    case mast = "MAST"
    case navcam = "NAVCAM"
    case pancam = "PANCAM"
    case minites = "MINITES"
    
    var fullName: String {
        switch self {
        case .fhaz:
            return "Front Hazard Avoidance Camera"
        case .rhaz:
            return "Rear Hazard Avoidance Camera"
        case .mast:
            return "Mast Camera"
        case .navcam:
            return "Navigation Camera"
        case .pancam:
            return "Panoramic Camera"
        case .minites:
            return "Miniature Thermal Emission Spectrometer (Mini-TES)"
        }
    }
}

enum Rovers: String, CaseIterable {
    case curiosity = "Curiosity"
    case opportunity = "Opportunity"
    case spirit = "Spirit"
    
//    var cameras: [Camera] {
//        switch self {
//        case .curiosity:
//            return [.fhaz, .rhaz, .mast, .navcam, .pancam, .minites]
//        case .opportunity:
//            return [.fhaz, .rhaz, .navcam, .pancam]
//        case .spirit:
//            return [.fhaz, .rhaz, .navcam, .pancam]
//        }
//    }
//    
//    var launchDate: String {
//        switch self {
//        case .curiosity:
//            return "2011-11-26"
//        case .opportunity:
//            return "2003-07-07"
//        case .spirit:
//            return "2003-06-10"
//        }
//    }
}
