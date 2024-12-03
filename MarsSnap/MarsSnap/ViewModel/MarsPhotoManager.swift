//
//  MarsPhotoManager.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 16.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SwiftUI
import Alamofire

enum Link {
    case photos
    
    var url: URL {
        switch self {
        case .photos:
            return URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?api_key=T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu&sol=1000")!
        }
    }
}

enum NetworkError: Error {
    case noData
    case tooManyRequests
    case decodingError
}

final class MarsPhotoManager: ObservableObject {
    static let shared = MarsPhotoManager()
    
    private init() {}
    
    func fetchEmployees(from url: URL, completion: @escaping(Result<[Card], NetworkError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { responseData in
                switch responseData.result {
                case .success(let correctData):
                    let photos = self.parseEmployees(correctData)
                    completion(.success(photos))
                case .failure(let afError):
                    print("AF error: \(afError.localizedDescription)")
                    if responseData.response?.statusCode == 429 {
                        completion(.failure(.tooManyRequests))
                    } else {
                        completion(.failure(.noData))
                    }
                }
            }
    }
    
    private func parseEmployees(_ data: Data) -> [Card] {
        var photos = [Card]()
        if let decoded: Query = decode(data) {
            photos = decoded.photos
        }
        return photos
    }
}
