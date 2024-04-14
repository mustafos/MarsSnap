//
//  Mars.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import Foundation

//token = "T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu"
struct MarsData: Identifiable, Hashable {
    let id = UUID()
    let rover: String
    let camera: String
    let date: String
    let photo: String
}

struct Mars: Codable {
    let copyright: String
    let date: String
    let explanation: String
    let hdurl: String
    let title: String
}

