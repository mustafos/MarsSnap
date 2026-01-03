//
//  PhotoMiddleware.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 18.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

func photoMiddleware() -> Middleware<AppState> {
    { state, action, dispatch in
        switch action {
        case let action as FetchPhotos:
            let rover = action.request.rover
            let shouldLoadCameras = (state.filters.camerasByRover[rover] ?? []).isEmpty
            Task {
                do {
                    async let photosTask = Webservice().fetchPhotos(request: action.request, page: action.page)
                    let cameras = shouldLoadCameras ? try? await Webservice().fetchCameras(rover: rover) : nil
                    let page = try await photosTask
                    if let cameras, !cameras.isEmpty {
                        dispatch(SetRoverCameras(rover: rover, cameras: cameras))
                    }
                    dispatch(PhotosLoaded(
                        requestID: action.requestID,
                        page: page.page,
                        photos: page.photos,
                        hasMore: page.hasMore
                    ))
                } catch {
                    let message = (error as? LocalizedError)?.errorDescription ?? "Couldn't load photos."
                    dispatch(PhotosFailed(requestID: action.requestID, page: action.page, message: message))
                }
            }
        case is LoadHistory:
            dispatch(SetHistory(items: HistoryStore.load()))
        case is AddFilter, is DeleteFilter, is SetHistory:
            HistoryStore.save(state.history.items)
        default:
            break
        }
    }
}
