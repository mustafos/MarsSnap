//
//  MarsViewModel.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI

class MarsViewModel: ObservableObject {
    
    struct Constants {
        static let apiKey = "T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    @Published var mars = Mars(
        copyright: "",
        date: "",
        explanation: "",
        hdurl: "https://apod.nasa.gov/apod/image/1410/butterflyblue_hst_3919.jpg",
        title: ""
    )
    
    func fetch() {
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=" + Constants.apiKey + "&date=2014-10-01") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Mars.self, from: data)
                DispatchQueue.main.async {
                    self.mars = result
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
