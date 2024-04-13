//
//  GeneralFilterComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 13.04.2024.
//

import SwiftUI

struct GeneralFilterComponent: View {
    var isFilterCamera: Bool = true
    var body: some View {
        HeaderView()
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Button {
                withAnimation {
                    feedback.impactOccurred()
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
                }
            } label: {
                Image("correct")
                    .frame(width: 44, height: 44)
            }
        }
        .padding(20)
    }
}
