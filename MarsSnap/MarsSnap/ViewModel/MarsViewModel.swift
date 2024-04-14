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
                        let data = Mars(rover: roverName, camera: cameraName, date: earthDate, imageUrl: imageUrl)
                        self.datas.append(data)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

enum Rover: String, CaseIterable, Identifiable {
    case all = "All"
    case perseverance = "Perseverance"
    case curiosity = "Curiosity"
    
    var id: String { self.rawValue}
}

enum Camera: String, CaseIterable, Identifiable {
    case all = "All"
    case FHAZ = "Front Hazard Avoidance Camera"
    case NAVCAM = "Navigation Camera"
    case MAST = "Mast Camera"
    case CHEMCAM = "Chemistry and Camera Complex"
    case MAHLI = "Mars Hand Lens Imager"
    case MARD = "Mars Descent Imager"
    case RHAZ = "Rear Hazard Avoidance Camera"
    
    var id: String { self.rawValue}
}

enum EarthDate: String, CaseIterable {
    case latest = "Latest"
}

extension MarsPhotoManager {
    func filteredData(selectedRover: Rover, selectedCamera: Camera, selectedEarthDate: EarthDate) -> [Mars] {
        var filteredData = datas
        
        // Filter by rover
        if selectedRover != .perseverance {
            filteredData = filteredData.filter { $0.rover.lowercased() == selectedRover.rawValue }
        }
        
        // Filter by camera
        if selectedCamera != .all {
            filteredData = filteredData.filter { $0.camera.lowercased() == selectedCamera.rawValue }
        }
        
        // Filter by earth date
        if selectedEarthDate != .latest {
            filteredData = filteredData.filter { $0.date == selectedEarthDate.rawValue }
        }
        
        return filteredData
    }
}
