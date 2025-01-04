//
//  AppReducer.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 18.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

func appReducer(_ state: AppState, _ action: Action) -> AppState {
    var state = state
    state.photos = photosReducer(state.photos, action)
    state.filters = filtersReducer(state.filters, action)
    return state
}
