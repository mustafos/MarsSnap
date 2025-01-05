//
//  MainView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 06.01.2025.
//  Copyright © 2025 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct MainView: View {
    @EnvironmentObject var store: Store<AppState>
    
    struct MainProps {
        var rover: String
        var camera: String?
        var date: String?
        var availableCameras: [RoverCameras]
        var photos: [Photo]
    }
    
    var body: some View {
        let props = map(state: store.state)
        
        return VStack {
            // Марсоход (rover)
            Picker("Select Rover", selection: $store.state.filters.rover) {
                Text("Perseverance").tag("perseverance")
                Text("Curiosity").tag("curiosity")
                Text("Opportunity").tag("opportunity")
                Text("Spirit").tag("spirit")
            }
            .onChange(of: store.state.filters.rover) { newRover in
                store.dispatch(action: SetFilters(rover: newRover, camera: nil, date: nil))
                store.dispatch(action: FetchPhotos(rover: newRover, camera: nil, date: nil))
            }
            
            // Камера (camera) - динамически заполняется в зависимости от выбранного марсохода
            Picker("Select Camera", selection: $store.state.filters.camera) {
                Text("All Cameras").tag(nil as String?)
                ForEach(props.availableCameras, id: \.name) { camera in
                    Text(camera.fullName).tag(camera.name as String?)
                }
            }
            .onChange(of: store.state.filters.camera) { newCamera in
                store.dispatch(action: FetchPhotos(rover: store.state.filters.rover, camera: newCamera, date: store.state.filters.date))
            }
            
            // Новый DatePicker для выбора даты
            DatePicker(
                "Select Date",
                selection: Binding(
                    get: {
                        if let dateString = store.state.filters.date {
                            return stringToDate(dateString) ?? Date()
                        }
                        return Date()
                    },
                    set: { newDate in
                        store.state.filters.date = dateToString(newDate)
                    }
                ),
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            
            // Photo
            List(props.photos, id: \.imgSrc) { photo in
                NavigationLink {
                    // PhotoDetailsView(photo: photo)
                } label: {
                    PhotoCell(photo: photo)
                }
            }
            .listStyle(PlainListStyle())
            .onAppear {
                if !store.state.filters.rover.isEmpty {
                    store.dispatch(action: FetchPhotos(rover: store.state.filters.rover, camera: store.state.filters.camera, date: store.state.filters.date))
                }
            }
        }
        .navigationTitle("Mars Photos")
        .embedInNavigationView()
    }
}

private extension MainView {
    func map(state: AppState) -> MainProps {
        return MainProps(
            rover: state.filters.rover,
            camera: state.filters.camera,
            date: state.filters.date,
            availableCameras: state.filters.availableCameras,  // Здесь оставляем массив RoverCameras
            photos: state.photos.photos
        )
    }
    
    func stringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }

    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

#Preview {
    MainView()
}

import SDWebImageSwiftUI

struct PhotoCell: View {
    
    let photo: Photo
    
    var body: some View {
        HStack(alignment: .top) {
            WebImage(url: URL(string: photo.imgSrc))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .frame(width: 100, height: 80)
            
            //            URLImage(url: photo.imgSrc)
            //                .frame(width: 100, height: 130)
            //                .cornerRadius(10)
            VStack {
                Text(photo.rover.name)
                Text(photo.camera.fullName)
                Text(photo.earthDate)
            }
        }
    }
}

//struct PhotoDetailsView: View {
//    @EnvironmentObject var store: Store<AppState>
//    let photo: Photo
//
//    struct Props {
//        let details: [Photo]
//        let onLoadMovieDetails: (String) -> Void
//    }
//
//    private func map(state: PhotosState) -> Props {
//        Props(details: state.photos) { img in
//            store.dispatch(action: FetchPhotos(rover: img, camera: img, date: img))
//        }
//    }
//
//    var body: some View {
//        VStack {
//            let props = map(state: store.state.photos)
//
//            Group {
//                if let details = props.details {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Spacer()
////                            URLImage(url: details.first?.imgSrc!)
//                            Spacer()
//                        }
//
//                        Text(details.count.description)
//                            .padding(5)
//                            .font(.title)
////                        Text(details.endIndex.codingKey)
//                            .padding(5)
//
//                        Spacer()
//
//                    }
//                } else {
//                    Text("Loading...")
//                }
//            }
//            .onAppear {
////                props.onLoadMovieDetails(movie.imdbId)
//            }
//        }
//    }
//}

struct URLImage: View {
    
    let url: String
    @ObservedObject private var imageDownloader: ImageDownloader = ImageDownloader()
    
    init(url: String) {
        self.url = url
        self.imageDownloader.downloadImage(url: self.url)
    }
    
    var body: some View {
        if let imageData = self.imageDownloader.downloadedData {
            let img = UIImage(data: imageData)
            return VStack {
                Image(uiImage: img!).resizable()
            }
        } else {
            return VStack {
                Image(systemName: "photo")
            }
        }
    }
}

class ImageDownloader: ObservableObject {
    
    @Published var downloadedData: Data? = nil
    
    func downloadImage(url: String) {
        guard let imageURL = URL(string: url) else {
            fatalError("ImageURL is incorrect")
        }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadedData = data
            }
        }
    }
}

