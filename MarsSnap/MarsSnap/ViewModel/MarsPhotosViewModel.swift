//
//  MarsPhotosViewModel.swift
//  MarsSnap
//  
//  Created by Mustafa Bekirov on 11.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import SwiftUI
import Combine

class MarsPhotosViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var rovers: [Rover] = []
    @Published var cameras: [Camera] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?sol=1000&api_key=T9f55mAkKU4eIDFxBC9viMRytowhjzcNrh4dtanu") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MarsPhotosResponse.self, decoder: JSONDecoder())
            .map(\.photos)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.photos, on: self)
            .store(in: &cancellables)
    }
}

struct MarsPhotosResponse: Codable {
    let photos: [Photo]
}
