//
//  Mars.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import Foundation

struct MarsData: Identifiable, Hashable {
    let id = UUID()
    let rover: String
    let camera: String
    let date: String
    let photo: String
}
