//
//  PhotosReducer.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 18.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

func photosReducer(_ state: PhotosState, _ action: Action) -> PhotosState {
    var state = state
    
    switch action {
    case let action as SetPhotos:
        state.photos = action.photos
    default:
        break
    }
    return state
}
