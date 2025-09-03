//
//  Constants.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation
import UIKit

enum Haptics {
    static func tap() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        generator.impactOccurred()
    }
}

enum MarsCalendar {
    static func date(from day: String) -> Date? {
        makeFormatter().date(from: day)
    }

    static func string(from date: Date) -> String {
        makeFormatter().string(from: date)
    }

    /// The archive treats `date_to` as exclusive, so a single Earth day needs the next day.
    static func dayAfter(_ day: String) -> String? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        guard let date = date(from: day),
              let next = calendar.date(byAdding: .day, value: 1, to: date) else {
            return nil
        }
        return string(from: next)
    }

    static func display(_ day: String) -> String {
        guard let date = date(from: day) else { return day }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    private static func makeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

struct Constants {
    /// NASA's Mars Rover Photos API is retired. This archive serves the same rovers without an API key.
    struct Urls {
        static let photosBase = URL(string: "https://api.voidindex.space/mars")!
    }
}
