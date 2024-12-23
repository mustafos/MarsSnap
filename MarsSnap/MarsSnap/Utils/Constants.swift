//
//  Constants.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

//import Foundation
//import SwiftUI
//
//struct Constants {
//    static let key = "T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu"
//    
//    static let baseURL = "https://api.nasa.gov/mars-photos/"
//    
//    static let feedback = UIImpactFeedbackGenerator(style: .soft)
//}

import Foundation

struct Constants {
    struct ApiKeys {
        static let securKey = "T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu"
    }
    
    struct Urls {
        static func urlForMarsPhotoByRoverCameraDate(rover: String, camera: String?, date: String?) -> String {
            // Rovers: Curiosity, Opportunity, Spirit, Perseverance
            // Camera: Front Hazard Avoidance Camera(FHAZ) * Rear Hazard Avoidance Camera(RHAZ) * Navigation Camera(NAVCAM)
            // Date Formatt 2015-6-3
            if camera != nil && date != nil {
                "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?sol=1000&camera=\(camera!)&earth_date=\(date!)&api_key=\(ApiKeys.securKey)"
            } else if camera != nil && date == nil {
                "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?sol=1000&camera=\(camera!)&api_key=\(ApiKeys.securKey)"
            } else {
            "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?api_key=\(ApiKeys.securKey)&sol=1000"
            }
        }
    }
}

//rover = "perseverance, curiosity, opportunity, spirit
