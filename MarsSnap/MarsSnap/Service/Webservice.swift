//
//  Webservice.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 16.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    
    var warningMessage: String {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid. Please check the URL and try again."
        case .invalidResponse:
            return "The server returned an invalid response. Please try again later."
        case .invalidData:
            return "The data received is corrupted or invalid. Please try again."
        }
    }
}

class Webservice {
    
    func getMarsPhotosBy(rover: String, camera: String?, date: String?, completion: @escaping (Result<[Photo]?, NetworkError>) -> Void) {
        guard let photoURL = URL(string: Constants.Urls.urlForMarsPhotoByRoverCameraDate(rover: rover, camera: camera, date: date)) else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("Requesting URL: \(photoURL)") // Debug: Print the constructed URL
        
        URLSession.shared.dataTask(with: photoURL) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let photoResponse = try? JSONDecoder().decode(PhotoResponse.self, from: data)
            if let photoResponse = photoResponse {
                completion(.success(photoResponse.photos))
            } else {
                completion(.failure(.invalidResponse))
            }
        }.resume()
    }
}
