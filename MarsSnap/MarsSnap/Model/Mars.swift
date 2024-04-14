//
//  Mars.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import Foundation

struct Mars: Identifiable, Decodable, Comparable {
    var id = UUID()
    var rover: String
    var camera: String
    var date: String
    var imageUrl: String?

    static func < (lhs: Mars, rhs: Mars) -> Bool {
        // Define your sorting criteria here
        if lhs.rover != rhs.rover {
            return lhs.rover < rhs.rover
        } else if lhs.camera != rhs.camera {
            return lhs.camera < rhs.camera
        } else {
            return lhs.date < rhs.date
        }
    }
}
