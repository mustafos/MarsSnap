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
    case let action as FetchPhotos:
        if action.page > 1 {
            guard action.requestID == state.requestID else { break }
            state.isLoadingMore = true
            state.errorMessage = nil
        } else {
            state.requestID = action.requestID
            state.isLoading = true
            state.isLoadingMore = false
            state.errorMessage = nil
            if state.query != action.request.key {
                state.photos = []
                state.page = 1
                state.hasMore = false
                state.query = action.request.key
            }
        }
    case let action as PhotosLoaded:
        guard action.requestID == state.requestID else { break }
        if action.page <= 1 {
            state.photos = action.photos
        } else {
            let existing = Set(state.photos.map(\.id))
            state.photos.append(contentsOf: action.photos.filter { !existing.contains($0.id) })
        }
        state.page = action.page
        state.hasMore = action.hasMore
        state.isLoading = false
        state.isLoadingMore = false
        state.errorMessage = nil
    case let action as PhotosFailed:
        guard action.requestID == state.requestID else { break }
        state.isLoading = false
        state.isLoadingMore = false
        state.errorMessage = action.message
        if action.page <= 1, state.photos.isEmpty {
            state.hasMore = false
        }
    case is ClearPhotoError:
        state.errorMessage = nil
    default:
        break
    }
    return state
}
