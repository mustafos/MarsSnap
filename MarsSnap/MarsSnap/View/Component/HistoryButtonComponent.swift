//
//  HistoryButtonComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI

struct HistoryButtonComponent: View {
    @State private var dragAmount: CGPoint?
    @State private var opacityState: Double = 1
    var action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Circle()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.accentColor)
                        .shadow(radius: 3)
                        .overlay(Image("archive"))
                        .opacity(opacityState)
                        .onTapGesture {
                            action()
                            withAnimation(.linear(duration: 0.1)) {
                                opacityState = 0.2
                            }
                            withAnimation(.linear(duration: 0.1).delay(0.1)) {
                                opacityState = 1
                            }
                        }
                        .position(dragAmount ?? CGPoint(x: geometry.size.width-60, y: geometry.size.height-100))
                        .gesture(
                            DragGesture()
                                .onChanged { self.dragAmount = $0.location }
                                .onEnded { value in
                                    var currentPosition = value.location
                                    if currentPosition.x > (geometry.size.width / 2) {
                                        currentPosition.x = geometry.size.width-60
                                    } else {
                                        currentPosition.x = 60
                                    }
                                    
                                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10, initialVelocity: 0)) {
                                        dragAmount = currentPosition
                                    }
                                }
                        )
                } //: VSTACK
            } //: HSTACK
        }
    }
}
