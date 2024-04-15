//
//  APIService.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 15.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import Foundation
import Combine

struct APIService {
    
    static func createFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static  func createURL(for date: Date) -> URL {
        let formatter = APIService.createFormatter()
        let dateString = formatter.string(from: date)
        
        let url = URL(string: Constants.baseURL)!
        let fullURL = url.withQuery(["api_key" : Constants.key, "date" : dateString])!
        
        return fullURL
    }
    

    static func createDate(daysFromToday: Int) -> Date {
        let today = Date()
        if let newDate = Calendar.current.date(byAdding: .day, value: -daysFromToday, to: today) {
            return newDate
        }else {
            return today
        }
    }
}
