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
    private var currentPage = 1
    private var isLoading = false
    
    init() {
        // Immediately fetch the first page of photos when the view model is initialized
        fetchPhotos(page: currentPage)
    }
    
    func fetchPhotos(page: Int) {
        guard !isLoading else { return }
        
        isLoading = true
        
        let apiKey = "T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu"
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?sol=1000&page=\(page)&api_key=\(apiKey)"
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
