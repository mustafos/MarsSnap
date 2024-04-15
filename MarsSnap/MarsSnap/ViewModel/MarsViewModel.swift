//
//  MarsViewModel.swift
//  MarsSnap
//  //token = "T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu"
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import Kingfisher

class MarsPhotoManager: ObservableObject {
    @Published var datas = [Mars]()
    var selectedRover: Rover // Declare selectedRover property
    
    init(selectedRover: Rover) {
        self.selectedRover = selectedRover
        fetchPhotos()
    }
    
    func fetchPhotos() {
        let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?api_key=T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu&sol=1000"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json) // Print the JSON response
                
                // Assuming the JSON structure is similar to the example website
                if let photos = json["photos"].array {
                    for photo in photos {
                        let roverName = photo["rover"]["name"].stringValue
                        let cameraName = photo["camera"]["full_name"].stringValue
                        let earthDate = photo["earth_date"].stringValue
                        let imageUrl = photo["img_src"].stringValue
                        let data = Mars(id: UUID(), roverName: roverName, cameraFullName: cameraName, earthDate: earthDate, imgSrc: imageUrl)
                        self.datas.append(data)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
    private func generateURL(for rover: Rover) -> String {
        let roverName = rover.rawValue.lowercased()
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(roverName)/photos?api_key=T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu&sol=1000"
        return urlString
    }
}

enum Rover: String, CaseIterable, Identifiable {
    case all = "All"
    case curiosity = "Curiosity"
    case perseverance = "Perseverance"
    case spirit = "Spirit"
    case opportunity = "Opportunity"
    
    var id: String { self.rawValue }
}

enum Camera: String, CaseIterable, Identifiable {
    case all = "All"
    case Mastcam = "Mast Camera"
    case ChemCam = "ChemCam"
    case Navcam = "Navigation Camera"
    case Hazcam = "Hazard Avoidance Camera"
    case Pancam = "Panoramic Camera"
    case Microscopic = "Microscopic Imager"
    case Parachute = "Descent Stage Down-Look Camera"
    case Lander = "Lander Vision System Camera"
    
    var id: String { self.rawValue }
}

enum EarthDate: String, CaseIterable {
    case latest = "Latest"
}

extension MarsPhotoManager {
    func filteredData(selectedRover: Rover, selectedCamera: Camera, selectedEarthDate: EarthDate) -> [Mars] {
        var filteredData = datas
        
        // Filter by rover
        if selectedRover != .perseverance {
            filteredData = filteredData.filter { $0.roverName.lowercased() == selectedRover.rawValue.lowercased() }
        }
        
        // Filter by camera
        if selectedCamera != .all {
            filteredData = filteredData.filter { $0.cameraFullName.lowercased() == selectedCamera.rawValue.lowercased() }
        }
        
        // Filter by earth date
        if selectedEarthDate != .latest {
            filteredData = filteredData.filter { $0.earthDate == selectedEarthDate.rawValue }
        }
        
        return filteredData
    }
}
