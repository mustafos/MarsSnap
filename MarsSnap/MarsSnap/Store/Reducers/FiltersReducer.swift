//
//  FiltersReducer.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 18.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

func filtersReducer(_ state: FiltersState, _ action: Action) -> FiltersState {
    var state = state
    switch action {
    case let action as SetFilters:
        state.rover = action.request.rover
        state.camera = action.request.camera
        state.date = action.request.date
    case let action as SetRoverCameras:
        state.camerasByRover[action.rover] = action.cameras
    default:
        break
    }
    return state
}
