//
//  URL.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 15.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import Foundation

extension URL {
    func withQuery(_ query: [String: String]) -> URL? {
        // adds query to URL in correct format
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = query.map { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
