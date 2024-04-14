//
//  AsyncImageView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 14.04.2024.
//

import SwiftUI
import Kingfisher

struct AsyncImageView: View {
    private let imageUrl: String
    private let placeholder: Image
    
    init(imageUrl: String, placeholder: Image = Image(systemName: "photo")) {
        self.imageUrl = imageUrl
        self.placeholder = placeholder
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            KFImage(URL(string: imageUrl))
                .placeholder({
                    placeholder
                })
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            // Fallback for iOS 13
            ImageView(imageUrl: imageUrl, placeholder: placeholder)
        }
    }
}

struct ImageView: View {
    @State private var image: UIImage?
    private let imageUrl: String
    private let placeholder: Image
    
    init(imageUrl: String, placeholder: Image) {
        self.imageUrl = imageUrl
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                placeholder
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let loadedImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }.resume()
    }
}
