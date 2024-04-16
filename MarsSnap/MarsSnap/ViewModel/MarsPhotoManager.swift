//
//  MarsPhotoManager.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 16.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import SwiftUI

enum Link {
    case employees
    
    var url: URL {
        switch self {
        case .employees:
            return URL(string: "https://dummy.restapiexample.com/api/v1/employees")!
        }
    }
}

enum NetworkError: Error {
    case noData
    case tooManyRequests
    case decodingError
}

final class MarsPhotoManager: ObservableObject {
    
    init() {}
    
    static let shared = MarsPhotoManager()
    
    func fetchEmployees(completion: @escaping (Result<[Employee], NetworkError>) -> Void) {
        print("try to fetch")
        
        let fetchRequest = URLRequest(url: Link.employees.url)
        
        URLSession.shared.dataTask(with: fetchRequest) { (data, response, error) -> Void in
            if error != nil {
                print("Error in session is not nil")
                completion(.failure(.noData))
            } else {
                // We've got data!
                let httpResponse = response as? HTTPURLResponse
                print("status code: \(String(describing: httpResponse?.statusCode ?? 0))")
                
                if httpResponse?.statusCode == 429 {
                    completion(.failure(.tooManyRequests))
                } else {
                    guard let safeData = data else { return }
                    
                    do {
                        let decodedQuery = try JSONDecoder().decode(Query.self, from: safeData)
                        
                        completion(.success(decodedQuery.data))
                        
                    } catch let decodeError {
                        print("Decoding error: \(decodeError)")
                        completion(.failure(.decodingError))
                    }
                }
            }
        }
        .resume()
    }
}
