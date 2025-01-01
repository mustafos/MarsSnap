//
//  PhotosReducer.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 18.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

func filtersReducer(_ state: FiltersState, _ action: Action) -> FiltersState {
    var state = state
    switch action {
    case let action as SetFilters:
        state.rover = action.rover
        state.camera = action.camera
        state.date = action.date
        state.availableCameras = [] // Очищаем список доступных камер, чтобы он обновился
    case let action as SetAvailableCameras: // Новый экшн для обновления списка камер
        state.availableCameras = action.cameras
    default:
        break
    }
    return state
}
