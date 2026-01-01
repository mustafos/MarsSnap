//
//  History.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 14.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

struct SavedFilter: Codable, Identifiable, Hashable {
    let id: UUID
    let rover: String
    let camera: String?
    let date: String?
    let savedAt: Date

    func matches(_ request: PhotoRequest) -> Bool {
        rover == request.rover && camera == request.camera && date == request.date
    }
}

enum HistoryStore {
    private static let key = "mars.savedFilters"
    private static let limit = 20

    static func load() -> [SavedFilter] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([SavedFilter].self, from: data)) ?? []
    }

    static func save(_ items: [SavedFilter]) {
        let trimmed = Array(items.prefix(limit))
        guard let data = try? JSONEncoder().encode(trimmed) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
