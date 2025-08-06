//
//  AsyncImageView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 14.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import SDWebImageSwiftUI
import SwiftUI

struct AsyncImageView: View {
    let imageUrl: URL
    var contentMode: ContentMode = .fill

    var body: some View {
        WebImage(url: imageUrl)
            .resizable()
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .aspectRatio(contentMode: contentMode)
    }
}
