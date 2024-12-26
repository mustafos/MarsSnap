//
//  Photo.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

struct PhotoResponse: Decodable {
    let photos: [Photo]
}

struct Photo: Decodable {
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover
    
    private enum CodingKeys: String, CodingKey {
        case camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

struct Camera: Decodable {
    let fullName: String
    
    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}

struct Rover: Decodable {
    let name: String
}
