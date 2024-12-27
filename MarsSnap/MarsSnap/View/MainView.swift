//
//  MainView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 06.01.2025.
//  Copyright © 2025 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct MainView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var rover: String = ""
    @State private var camera: String = ""
    @State private var date: String = ""
    
    struct Props {
        let photos: [Photo]
        let onRover: (String) -> Void
        let onCamera: (String) -> Void
        let onDate: (String) -> Void
    }
    
    private func map(state: PhotosState) -> Props {
        Props(photos: state.photos) { roverType in
            store.dispatch(action: FetchPhotos(rover: roverType, camera: camera, date: date))
        } onCamera: { cameraType in
            store.dispatch(action: FetchPhotos(rover: rover, camera: cameraType, date: date))
        } onDate: { earthDate in
            store.dispatch(action: FetchPhotos(rover: rover, camera: camera, date: earthDate))
        }
    }
    
    var body: some View {
        let props = map(state: store.state.photos)
        VStack {
            HStack {
                Button("Perseverance") {
                    rover = "perseverance"
                }
                Button("Curiosity") {
                    rover = "curiosity"
                }
                Button("Opportunity") {
                    rover = "opportunity"
                }
                Button("Spirit") {
                    rover = "spirit"
                }
            }
            
            VStack(spacing: 5) {
                Button("Front Hazard Avoidance Camera") {
                    camera = "fhaz"
                }
                Button("Rear Hazard Avoidance Camera") {
                    camera = "rhaz"
                }
                Button("Navigation Camera") {
                    camera = "navcam"
                }
            }
            
            Button("Search") {
                props.onRover(rover)
                props.onCamera(camera)
                props.onDate(date)
            }

            List(props.photos, id: \.imgSrc) { photo in
                NavigationLink {
//                    PhotoDetailsView(photo: photo)
                } label: {
                    PhotoCell(photo: photo)
                }
            }.listStyle(PlainListStyle())
        }
        .navigationTitle("Mars Photos")
        .embedInNavigationView()
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

