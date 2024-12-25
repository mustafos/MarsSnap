//
//  PhotoMiddleware.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 18.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

func photoMiddleware() -> Middlewere<AppState> {
    return { state, action, dispatch in
        switch action {
        case let action as FetchPhotos:
            Webservice().getMarsPhotosBy(rover: action.rover, camera: action.camera, date: action.date) { result in
                switch result {
                case .success(let photos):
                    if let photos = photos {
                        // set photos to the state
                        dispatch(SetPhotos(photos: photos))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
}
