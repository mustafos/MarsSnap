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
    @Binding var selectedFilter: String
    var positiveButtonAction: ((String) -> ())? = nil
    var negativeButtonAction: (() -> ())? = {}
    
    var colors = ["Red", "Green", "Blue", "Tartan"]
    
    // MARK: – BODY
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            Spacer()
            VStack {
                HeaderView()
                Picker("Please choose a color", selection: $selectedFilter) {
                    ForEach(colors, id: \.self) {
                        Text($0)
                    }
                }
                Text("You selected: \(selectedFilter)")
            } //: VSTACK
            .frame(maxWidth: .infinity, maxHeight: 306)
            .background(Color.backgroundOne)
            .cornerRadius(50)
        } //: ZSTACK
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
                    positiveButtonAction?(selectedFilter)
                }
            } label: {
                Image("correct")
                    .frame(width: 44, height: 44)
            }
        }
        .padding(20)
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
