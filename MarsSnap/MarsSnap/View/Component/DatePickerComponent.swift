//
//  DatePickerComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 13.04.2024.
//

import SwiftUI

struct DatePickerComponent: View {
    
    // MARK: – PROPERTIES
    var title: String
    @Binding var selectedDate: Date
    var positiveButtonAction: ((Date) -> ())? = nil
    var negativeButtonAction: (() -> ())? = {}
    
    // MARK: – BODY
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HeaderView()
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .padding(.horizontal, 20)
            }
            .frame(maxWidth: 353, maxHeight: 312)
            .background(Color.backgroundOne)
            .cornerRadius(50)
        }
        .zIndex(2)
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Button {
                negativeButtonAction?()
            } label: {
                Image("close")
                    .frame(width: 44, height: 44)
            }
            Spacer()
            
            Text(title)
                .font(.system(size: 22, weight: .bold))
            
            Spacer()
            Button {
                positiveButtonAction?(selectedDate)
            } label: {
                Image("correct")
                    .frame(width: 44, height: 44)
            }
        }
        .padding(20)
    }
}

extension DatePickerComponent {
    func onPositiveButtonTap(_ positiveButtonAction: ((Date) -> ())?) -> Self {
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
