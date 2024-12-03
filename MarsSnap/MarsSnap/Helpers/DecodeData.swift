//
//  DecodeData.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 22.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

func decode<T: Decodable>(_ data: Data) -> T? {
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        print(error)
        return nil
    }
}
