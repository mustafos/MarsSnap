//
//  WarningMessage.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 16.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

func warningMessage(error: NetworkError) -> String {
    switch error {
    case .noData:
        return "Data cannot be found at this URL"
    case .tooManyRequests:
        return "429: Too many requests"
    case .decodingError:
        return "Can't decode data"
    }
}
