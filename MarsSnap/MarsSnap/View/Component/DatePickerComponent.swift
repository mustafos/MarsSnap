//
//  DatePickerComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 13.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct DatePickerComponent: View {
    var title: String
    @Binding var selectedDate: Date
    var minimumDate: Date
    var maximumDate: Date
    var positiveButtonAction: ((Date) -> Void)?
    var negativeButtonAction: (() -> Void)?

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { negativeButtonAction?() }

            VStack(spacing: 0) {
                header
                DatePicker(
                    "Select the earth date",
                    selection: $selectedDate,
                    in: minimumDate...maximumDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
            .frame(maxWidth: 353)
            .background(Color.backgroundOne)
            .cornerRadius(28)
            .padding(.horizontal, 20)
        }
    }

    private var header: some View {
        HStack {
            Button {
                Haptics.tap()
                negativeButtonAction?()
            } label: {
                Image("close")
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Cancel")

            Spacer()

            Text(title)
                .font(.system(size: 22, weight: .bold))

            Spacer()

            Button {
                Haptics.tap()
                positiveButtonAction?(selectedDate)
            } label: {
                Image("correct")
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Apply date")
        }
        .padding(20)
    }
}

extension DatePickerComponent {
    func onPositiveButtonTap(_ positiveButtonAction: ((Date) -> Void)?) -> Self {
        var alert = self
        alert.positiveButtonAction = positiveButtonAction
        return alert
    }

    func onNegativeButtonTap(_ negativeButtonAction: (() -> Void)?) -> Self {
        var alert = self
        alert.negativeButtonAction = negativeButtonAction
        return alert
    }
}
