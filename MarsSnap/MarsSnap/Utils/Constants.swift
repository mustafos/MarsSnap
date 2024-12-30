//
//  Constants.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

// TODO: Добавить логику вибрации как отдельный функционал static let feedback = UIImpactFeedbackGenerator(style: .soft)
//rover = "perseverance, curiosity, opportunity, spirit

import Foundation

struct Constants {
    struct ApiKeys {
        static let securKey = "T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu"
    }
    
    struct Urls {
        static func urlForMarsPhotoByRoverCameraDate(rover: String, camera: String? = nil, date: String? = nil) -> String {
            var urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?sol=1000"
            
            // Добавляем камеру, если она задана
            if let camera = camera {
                urlString += "&camera=\(camera.lowercased())"
            }
            
            // Добавляем дату, если она задана
            if let date = date, !date.isEmpty {
                urlString += "&earth_date=\(date)"
            }
            
            // Добавляем ключ API
            urlString += "&api_key=\(ApiKeys.securKey)"
            
            return urlString
        }
    }
}
