//
//  MarsPhotosViewModel.swift
//  MarsSnap
//  
//  Created by Mustafa Bekirov on 11.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

//import SwiftUI
//import Alamofire
//import SwiftyJSON
//
//class MarsPhotosViewModel: ObservableObject {
//    @Published var cards: [Card] = []
//    @Published var cameras: [Cameras] = []
//    private var currentRover = "perseverance"
//    private var currentCamera = "&camera=fhaz"
//    private var currentDate = "&earth_date=2015-6-3"
//    private var isSol = true
//    private var isLoading = false
//    
//    init() {
//        // Immediately fetch the first page of photos when the view model is initialized
//        fetchMarsData(rover: currentRover, camera: "", date: "", sol: isSol)
//    }
//    
//    func fetchMarsData(rover: String, camera: String?, date: String?, sol: Bool) {
//        guard !isLoading else { return }
//        
//        isLoading = true
//        
//        let apiKey = "T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu"
//        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?api_key=\(apiKey)\(isSol ? "&sol=1000" : "")\(date ?? "")\(camera ?? "")"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL:", urlString)
//            return
//        }
//        
//        print("Fetching data from:", url)
//        
//        AF.request(urlString).responseJSON { response in
//            defer { self.isLoading = false }
//            
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                let photoArray = json["photos"].arrayValue.compactMap { json in
//                    return Card.card
//                }
//                
//                let cameraArray = json["photos"].arrayValue.compactMap { json in
//                    return Cameras.camera
//                }
//                DispatchQueue.main.async {
//                    self.cards.append(contentsOf: photoArray)
//                    self.cameras.append(contentsOf: cameraArray)
//                    self.objectWillChange.send() // Trigger view update
//                }
//            case .failure(let error):
//                print("Error fetching data:", error)
//            }
//        }
//    }
//}
