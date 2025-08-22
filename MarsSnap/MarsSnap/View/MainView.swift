//
//  MainView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 06.01.2025.
//  Copyright © 2025 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct MainView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var didLaunch = false
    @State private var showDatePicker = false
    @State private var showRoverPicker = false
    @State private var showCameraPicker = false
    @State private var showSaveAlert = false
    @State private var saveAlertIsDuplicate = false
    @State private var draftDate = Date()

    private var photos: PhotosState { store.state.photos }
    private var filters: FiltersState { store.state.filters }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                header
                content
            }
            historyButton
            overlays
        }
        .background(Color.accentOne.ignoresSafeArea())
        .navigationBarHidden(true)
        .alert(isPresented: $showSaveAlert) { saveAlert }
        .embedInNavigationView()
        .onAppear(perform: startIfNeeded)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("mars.camera".uppercased())
                        .font(.system(size: 34, weight: .bold))
                    HStack(spacing: 8) {
                        Text(filters.date.map(MarsCalendar.display) ?? "Latest")
                        if photos.isLoading, !photos.photos.isEmpty {
                            ProgressView()
                        }
                    }
                    .foregroundColor(.black.opacity(0.8))
                }
                Spacer()
                Button {
                    Haptics.tap()
                    draftDate = filters.date.flatMap(MarsCalendar.date(from:)) ?? Date()
                    showDatePicker = true
                } label: {
                    Image("calendar")
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Choose date")
            }

            HStack(spacing: 8) {
                filterButton(
                    icon: "cpu",
                    title: Rover(rawValue: filters.rover)?.title ?? filters.rover.capitalized
                ) {
                    showRoverPicker = true
                }
                filterButton(icon: "camera", title: cameraTitle(filters.camera, rover: filters.rover)) {
                    showCameraPicker = true
                }
                Button {
                    Haptics.tap()
                    saveAlertIsDuplicate = store.state.history.items.contains { $0.matches(filters.request) }
                    showSaveAlert = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                        .background(Color.white.cornerRadius(10))
                }
                .accessibilityLabel("Save filters")
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.accentOne)
    }

    private var content: some View {
        ZStack {
            if photos.photos.isEmpty, photos.isLoading {
                VStack(spacing: 8) {
                    LottieView(animationFileName: "loader", loopMode: .loop)
                        .frame(width: 140, height: 140)
                    Text("Loading Mars photos")
                        .foregroundColor(.layerTwo)
                }
            } else if photos.photos.isEmpty, let message = photos.errorMessage {
                VStack(spacing: 12) {
                    Image("empty")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 150)
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.layerTwo)
                        .padding(.horizontal, 32)
                    Button("Try again") {
                        Haptics.tap()
                        reload()
                    }
                    .font(.headline)
                }
            } else if photos.photos.isEmpty {
                VStack(spacing: 12) {
                    Image("empty")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 193, height: 186)
                    Text("No photos for this filter.")
                        .foregroundColor(.layerTwo)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(photos.photos) { photo in
                            NavigationLink(destination: MarsImageView(
                                photo: photo,
                                cameraName: cameraTitle(photo.cameraCode, rover: photo.rover)
                            )) {
                                CardComponent(
                                    photo: photo,
                                    cameraName: cameraTitle(photo.cameraCode, rover: photo.rover)
                                )
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                loadMoreIfNeeded(photoID: photo.id)
                            }
                        }

                        if photos.isLoadingMore {
                            ProgressView()
                                .padding(.vertical, 8)
                        }

                        Text("Photos courtesy of NASA/JPL-Caltech.\nCopyright © 2026 Mustafa Bekirov.")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.layerTwo)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 90)
                    }
                    .padding(.top, 16)
                }
                .refreshable { await reloadAndWait() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundOne)
        .alert(isPresented: errorAlertPresented) {
            Alert(
                title: Text("Couldn't load photos"),
                message: Text(photos.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private var historyButton: some View {
        NavigationLink(destination: HistoryView()) {
            Circle()
                .frame(width: 70, height: 70)
                .foregroundColor(.accentOne)
                .shadow(radius: 5)
                .overlay(Image("archive"))
        }
        .accessibilityLabel("History")
        .padding(.trailing, 20)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var overlays: some View {
        if showDatePicker {
            DatePickerComponent(
                title: "Date",
                selectedDate: $draftDate,
                minimumDate: landingDate,
                maximumDate: Date()
            )
            .onNegativeButtonTap { showDatePicker = false }
            .onPositiveButtonTap { date in
                showDatePicker = false
                apply(PhotoRequest.make(
                    rover: filters.rover,
                    camera: filters.camera,
                    date: MarsCalendar.string(from: date)
                ))
            }
        }

        if showRoverPicker {
            GeneralFilterComponent(
                title: "Rover",
                options: Rover.allCases.map { FilterOption(id: $0.rawValue, title: $0.title) },
                selection: filters.rover,
                onCancel: { showRoverPicker = false },
                onConfirm: { rover in
                    showRoverPicker = false
                    apply(PhotoRequest.make(rover: rover, camera: nil, date: filters.date))
                }
            )
        }

        if showCameraPicker {
            GeneralFilterComponent(
                title: "Camera",
                options: cameraOptions,
                selection: filters.camera ?? "",
                onCancel: { showCameraPicker = false },
                onConfirm: { camera in
                    showCameraPicker = false
                    apply(PhotoRequest.make(
                        rover: filters.rover,
                        camera: camera.isEmpty ? nil : camera,
                        date: filters.date
                    ))
                }
            )
        }
    }

    private var cameraOptions: [FilterOption] {
        var options = [FilterOption(id: "", title: "All")]
        let cameras = (filters.camerasByRover[filters.rover] ?? []).sorted { $0.fullName < $1.fullName }
        options.append(contentsOf: cameras.map { FilterOption(id: $0.code, title: $0.fullName) })
        if let camera = filters.camera, !camera.isEmpty, !options.contains(where: { $0.id == camera }) {
            options.append(FilterOption(id: camera, title: camera))
        }
        return options
    }

    private var landingDate: Date {
        let day = Rover(rawValue: filters.rover)?.landingDay ?? Rover.spirit.landingDay
        return MarsCalendar.date(from: day) ?? Date(timeIntervalSince1970: 0)
    }

    private var errorAlertPresented: Binding<Bool> {
        Binding(
            get: { photos.errorMessage != nil && !photos.photos.isEmpty },
            set: { isShown in
                if !isShown { store.dispatch(action: ClearPhotoError()) }
            }
        )
    }

    private var saveAlert: Alert {
        if saveAlertIsDuplicate {
            return Alert(
                title: Text("Already saved"),
                message: Text("This rover, camera, and date are already in history."),
                dismissButton: .default(Text("OK"))
            )
        }
        return Alert(
            title: Text("Save Filters"),
            message: Text("The current filters and the date you have chosen can be saved to the filter history."),
            primaryButton: .default(Text("Save")) {
                let item = SavedFilter(
                    id: UUID(),
                    rover: filters.rover,
                    camera: filters.camera,
                    date: filters.date,
                    savedAt: Date()
                )
                store.dispatch(action: AddFilter(filter: item))
            },
            secondaryButton: .cancel()
        )
    }

    private func filterButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button {
            Haptics.tap()
            action()
        } label: {
            HStack(spacing: 7) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(1)
                Spacer(minLength: 0)
            }
            .padding(7)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.white.cornerRadius(10))
        }
    }

    private func cameraTitle(_ code: String?, rover: String) -> String {
        guard let code, !code.isEmpty else { return "All" }
        return filters.camerasByRover[rover]?.first { $0.code == code }?.fullName ?? code
    }

    private func startIfNeeded() {
        guard !didLaunch else { return }
        didLaunch = true
        store.dispatch(action: LoadHistory())
        reload()
    }

    private func reload() {
        apply(filters.request)
    }

    private func apply(_ request: PhotoRequest) {
        let normalized = PhotoRequest.make(rover: request.rover, camera: request.camera, date: request.date)
        store.dispatch(action: SetFilters(request: normalized))
        store.dispatch(action: FetchPhotos(request: normalized, page: 1, requestID: UUID()))
    }

    private func loadMoreIfNeeded(photoID: Int) {
        guard photos.hasMore,
              !photos.isLoading,
              !photos.isLoadingMore,
              photos.photos.last?.id == photoID else { return }
        store.dispatch(action: FetchPhotos(request: filters.request, page: photos.page + 1, requestID: photos.requestID))
    }

    private func reloadAndWait() async {
        let requestID = UUID()
        store.dispatch(action: FetchPhotos(request: filters.request, page: 1, requestID: requestID))
        for _ in 0..<200 {
            let state = store.state.photos
            if state.requestID != requestID || !state.isLoading { return }
            try? await Task.sleep(nanoseconds: 150_000_000)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(
            Store(reducer: appReducer, state: AppState(), middlewares: [photoMiddleware()])
        )
}
