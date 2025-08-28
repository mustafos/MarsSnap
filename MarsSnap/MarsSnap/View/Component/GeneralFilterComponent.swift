//
//  GeneralFilterComponent.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 13.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct FilterOption: Identifiable, Hashable {
    let id: String
    let title: String
}

struct GeneralFilterComponent: View {
    let title: String
    let options: [FilterOption]
    @State private var draftID: String
    var onCancel: () -> Void
    var onConfirm: (String) -> Void

    init(
        title: String,
        options: [FilterOption],
        selection: String,
        onCancel: @escaping () -> Void,
        onConfirm: @escaping (String) -> Void
    ) {
        self.title = title
        self.options = options
        let initial = options.contains(where: { $0.id == selection }) ? selection : (options.first?.id ?? "")
        _draftID = State(initialValue: initial)
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture(perform: onCancel)

            VStack(spacing: 0) {
                header
                if options.isEmpty {
                    Text("No options")
                        .foregroundColor(.layerTwo)
                        .padding(.bottom, 28)
                } else {
                    Picker(title, selection: $draftID) {
                        ForEach(options) { option in
                            Text(option.title).tag(option.id)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .padding(.bottom, 8)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundOne)
            .cornerRadius(28)
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        HStack {
            Button(action: {
                Haptics.tap()
                onCancel()
            }) {
                Image("close")
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Cancel")

            Spacer()

            Text(title)
                .font(.system(size: 22, weight: .bold))

            Spacer()

            Button(action: {
                Haptics.tap()
                onConfirm(draftID)
            }) {
                Image("correct")
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Apply")
        }
        .padding([.top, .horizontal], 20)
    }
}
