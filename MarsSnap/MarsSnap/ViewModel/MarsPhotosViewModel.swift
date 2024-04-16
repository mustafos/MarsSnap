//
//  MarsPhotosViewModel.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import SwiftUI
import Alamofire
import SwiftyJSON

class MarsPhotosViewModel: ObservableObject {
    @Published var photos: [MarsPhoto] = []
    @Published var availableRovers: [Rover] = []
    @Published var availableCameras: [Camera] = []
    private var isLoading = false
    
    func fetchPhotos(rover: String, camera: String, date: String) {
        guard !isLoading else { return }
        
        isLoading = true
        
        let apiKey = "T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu"
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?camera=\(camera)&earth_date=\(date)&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL:", urlString)
            return
        }
        
        print("Fetching data from:", url)
        
        AF.request(urlString).responseJSON { response in
            defer { self.isLoading = false }
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let photoArray = json["photos"].arrayValue.compactMap { json in
                    return MarsPhoto(
                        id: json["id"].intValue,
                        rover: Rover(id: json["rover"]["id"].intValue, name: json["rover"]["name"].stringValue),
                        camera: Camera(name: json["camera"]["name"].stringValue, fullName: json["camera"]["full_name"].stringValue),
                        earthDate: json["earth_date"].stringValue,
                        imgSrc: json["img_src"].stringValue
                    )
                }
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photoArray)
                    self.objectWillChange.send() // Trigger view update
                }
            case .failure(let error):
                print("Error fetching data:", error)
            }
        }
    }
}
