//
//  History.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 14.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import Foundation
import RealmSwift

class History: Object {
    @objc dynamic var selectedRover: String = ""
    @objc dynamic var selectedCamera: String = ""
    @objc dynamic var selectedEarthDate: Date = Date()
}
