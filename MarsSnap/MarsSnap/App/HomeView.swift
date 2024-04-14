//
//  HomeView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 14.04.2024.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import Kingfisher

struct HomeView: View {
    @ObservedObject var obs = Observer()
    @State private var selectedRover = Rover.perseverance
    @State private var selectedCamera = Camera.all
    @State private var selectedEarthDate = EarthDate.latest
    
    var body: some View {
        VStack {
            Picker("Rover", selection: $selectedRover) {
                ForEach(Rover.allCases, id: \.self) { rover in
                    Text(rover.rawValue.capitalized).tag(rover)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Picker("Camera", selection: $selectedCamera) {
                ForEach(Camera.allCases, id: \.self) { camera in
                    Text(camera.rawValue).tag(camera)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Picker("Earth Date", selection: $selectedEarthDate) {
                ForEach(EarthDate.allCases, id: \.self) { earthDate in
                    Text(earthDate.rawValue).tag(earthDate)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            List(obs.filteredData(selectedRover: selectedRover, selectedCamera: selectedCamera, selectedEarthDate: selectedEarthDate)) { data in
                VStack(alignment: .leading) {
                    Text("Rover: \(data.roverName)")
                        .font(.headline)
                    Text("Camera: \(data.cameraName)")
                        .font(.headline)
                    Text("Date: \(data.earthDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    if let imageUrl = data.imageUrl {
                        if #available(iOS 14.0, *) {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .padding(.vertical, 4)
                        } else {
                            // Fallback for iOS 13
                            AsyncImageView(imageUrl: imageUrl)
//                            AsyncImage(url: URL(string: imageUrl)) { image in
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                            } placeholder: {
//                                ProgressView()
//                            }
//                            .frame(maxWidth: .infinity, maxHeight: 200)
                        }
                    }
                }
            }
            .navigationBarTitle("Mars Rover Photos")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

class Observer: ObservableObject {
    @Published var datas = [MarsPhoto]()
    
    init() {
        fetchPhotos()
    }
    
    func fetchPhotos() {
        let rover = "perseverance" // Default rover
        let sol = "1000" // Default sol
        
        AF.request("https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?sol=\(sol)&api_key=T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu").responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let photos = json["photos"].array {
                    for photo in photos {
                        let roverName = photo["rover"]["name"].stringValue
                        let cameraName = photo["camera"]["full_name"].stringValue
                        let earthDate = photo["earth_date"].stringValue
                        let imageUrl = photo["img_src"].stringValue
                        let data = MarsPhoto(roverName: roverName, cameraName: cameraName, earthDate: earthDate, imageUrl: imageUrl)
                        self.datas.append(data)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct MarsPhoto: Identifiable, Decodable {
    var id = UUID()
    var roverName: String
    var cameraName: String
    var earthDate: String
    var imageUrl: String?
}

enum Rover: String, CaseIterable {
    case perseverance
    case curiosity
    // Add more rovers if needed
}

enum Camera: String, CaseIterable {
    case all = "All"
    // Add more cameras if needed
}

enum EarthDate: String, CaseIterable {
    case latest = "Latest"
    // Add more earth dates if needed
}

extension Observer {
    func filteredData(selectedRover: Rover, selectedCamera: Camera, selectedEarthDate: EarthDate) -> [MarsPhoto] {
        var filteredData = datas
        
        // Filter by rover
        if selectedRover != .perseverance {
            filteredData = filteredData.filter { $0.roverName.lowercased() == selectedRover.rawValue }
        }
        
        // Filter by camera
        if selectedCamera != .all {
            filteredData = filteredData.filter { $0.cameraName.lowercased() == selectedCamera.rawValue }
        }
        
        // Filter by earth date
        if selectedEarthDate != .latest {
            filteredData = filteredData.filter { $0.earthDate == selectedEarthDate.rawValue }
        }
        
        return filteredData
    }
}
