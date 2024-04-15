//
//  Mars.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import Foundation

struct Mars: Identifiable, Decodable {
    let id: UUID
    let roverName: String
    let cameraFullName: String
    let earthDate: String
    let imgSrc: String
}
