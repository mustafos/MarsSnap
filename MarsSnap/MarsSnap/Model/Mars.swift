//
//  MarsPhoto.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import Foundation

struct MarsPhoto: Codable, Identifiable {
    let id: Int
    var rover: Rover
    let camera: Camera
    let earthDate: String
    let imgSrc: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case rover
        case camera
        case earthDate = "earth_date"
        case imgSrc = "img_src"
    }
}

struct Camera: Codable {
    let name: String
    let fullName: String?
}

struct Rover: Codable, Identifiable {
    let id: Int
    var name: String
}

// TODO: – Model for sort methods
//struct Photo: Identifiable {
//    let id = UUID()
//    let imageUrl: String
//}
//
//enum Rover: String, CaseIterable {
//    case curiosity
//    case opportunity
//    case spirit
//    
//    var cameras: [Camera] {
//        switch self {
//        case .curiosity:
//            return [.fhaz, .rhaz, .mast, .navcam, .pancam]
//        case .opportunity:
//            return [.fhaz, .rhaz, .navcam, .pancam]
//        case .spirit:
//            return [.fhaz, .rhaz, .navcam, .pancam]
//        }
//    }
//}
//
//enum Camera: String, CaseIterable {
//    case fhaz
//    case rhaz
//    case mast
//    case navcam
//    case pancam
//}
