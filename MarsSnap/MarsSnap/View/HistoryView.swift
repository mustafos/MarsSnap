//
//  HistoryView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: Store<AppState>
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedFilter: SavedFilter?
    @State private var showMenu = false

    var body: some View {
        VStack(spacing: 0) {
            header
            ZStack {
                if store.state.history.items.isEmpty {
                    VStack(spacing: 16) {
                        Image("empty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 193, height: 186)
                        Text("Saved filters will show up here.")
                            .foregroundColor(.layerTwo)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(store.state.history.items) { item in
                                Button {
                                    Haptics.tap()
                                    selectedFilter = item
                                    showMenu = true
                                } label: {
                                    FilterCardComponent(
                                        rover: item.rover.capitalized,
                                        camera: cameraTitle(for: item),
                                        date: item.date.map(MarsCalendar.display) ?? "Latest"
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundOne)
        }
        .background(Color.accentOne.ignoresSafeArea())
        .navigationBarHidden(true)
        .confirmationDialog("Saved filter", isPresented: $showMenu, titleVisibility: .visible) {
            Button("Use") { applySelected() }
            Button("Delete", role: .destructive) { deleteSelected() }
            Button("Cancel", role: .cancel) { selectedFilter = nil }
        } message: {
            if let selectedFilter {
                Text("\(selectedFilter.rover.capitalized) · \(selectedFilter.date.map(MarsCalendar.display) ?? "Latest")")
            }
        }
    }

    private var header: some View {
        ZStack {
            HStack {
                Button {
                    Haptics.tap()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("back")
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Back")
                Spacer()
            }
            Text("History")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(Color.accentOne)
    }

    private func cameraTitle(for item: SavedFilter) -> String {
        guard let code = item.camera, !code.isEmpty else { return "All" }
        return store.state.filters.camerasByRover[item.rover]?.first { $0.code == code }?.fullName ?? code
    }

    private func applySelected() {
        guard let selectedFilter else { return }
        Haptics.tap()
        let request = PhotoRequest.make(
            rover: selectedFilter.rover,
            camera: selectedFilter.camera,
            date: selectedFilter.date
        )
        store.dispatch(action: SetFilters(request: request))
        store.dispatch(action: FetchPhotos(request: request, page: 1, requestID: UUID()))
        self.selectedFilter = nil
        presentationMode.wrappedValue.dismiss()
    }

    private func deleteSelected() {
        guard let selectedFilter else { return }
        Haptics.tap()
        store.dispatch(action: DeleteFilter(id: selectedFilter.id))
        self.selectedFilter = nil
    }
}
