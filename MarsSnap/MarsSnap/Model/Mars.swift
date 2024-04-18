//
//  MarsPhoto.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import Foundation

struct Card: Decodable, Hashable {
    let id: Int
    let camera: Camera
    let img_src: String
    let earth_date: String
    let rover: Rover
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(camera.full_name)
        hasher.combine(img_src)
        hasher.combine(earth_date)
        hasher.combine(rover.name)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id &&
        lhs.camera.full_name == rhs.camera.full_name &&
               lhs.img_src == rhs.img_src &&
               lhs.earth_date == rhs.earth_date &&
        lhs.rover.name == rhs.rover.name
    }
}

struct Camera: Decodable {
    let full_name: String
}

struct Rover: Decodable {
    let name: String
    let cameras: [Cameras]
}

struct Cameras: Decodable, Hashable {
    let name: String
    let full_name: String
}

struct Query: Decodable {
    let photos: [Card]
}

// Sample data for extension purposes
extension Card {
    static let card = Card(id: 103383, camera: Camera(full_name: "Navigation Camera"), img_src: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/ncam/NLB_486272784EDR_F0481570NCAM00415M_.JPG", earth_date: "2015-05-30", rover: Rover(name: "Curiosity", cameras: []))
}

extension Cameras {
    static let camera = Cameras(name: "FHAZ", full_name: "Front Hazard Avoidance Camera")
}
