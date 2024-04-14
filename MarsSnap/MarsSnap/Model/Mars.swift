//
//  Mars.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import Foundation

struct Mars: Identifiable, Decodable {
    var id = UUID()
    var rover: String
    var camera: String
    var date: String
    var imageUrl: String?
}
