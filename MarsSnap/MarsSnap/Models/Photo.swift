//
//  Photo.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

enum Rover: String, CaseIterable, Identifiable {
    case perseverance
    case curiosity
    case opportunity
    case spirit

    var id: String { rawValue }

    var title: String { rawValue.capitalized }

    var landingDay: String {
        switch self {
        case .perseverance: return "2021-02-18"
        case .curiosity: return "2012-08-06"
        case .opportunity: return "2004-01-25"
        case .spirit: return "2004-01-04"
        }
    }
}

struct RoverCamera: Identifiable, Hashable {
    var id: String { code }
    let code: String
    let fullName: String
}

struct PhotoRequest: Equatable {
    var rover: String
    var camera: String?
    var date: String?

    var key: String { "\(rover)|\(camera ?? "")|\(date ?? "")" }

    static func make(rover: String, camera: String?, date: String?) -> PhotoRequest {
        let resolved = Rover(rawValue: rover.lowercased()) ?? .curiosity
        var earthDate: String?
        if let date, !date.isEmpty,
           let picked = MarsCalendar.date(from: date),
           let landing = MarsCalendar.date(from: resolved.landingDay),
           picked >= landing {
            earthDate = MarsCalendar.string(from: picked)
        }
        let cameraCode = (camera?.isEmpty == false) ? camera : nil
        return PhotoRequest(rover: resolved.rawValue, camera: cameraCode, date: earthDate)
    }
}

struct Photo: Identifiable, Hashable {
    let id: Int
    let sol: Int
    let cameraCode: String
    let earthDate: String
    let imageURL: URL
    let rover: String
    let title: String

    var roverTitle: String { rover.capitalized }
}
