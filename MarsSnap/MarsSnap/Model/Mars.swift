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
