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
    state.history = historyReducer(state.history, action)
    return state
}

func historyReducer(_ state: HistoryState, _ action: Action) -> HistoryState {
    var state = state
    switch action {
    case let action as SetHistory:
        state.items = action.items
    case let action as AddFilter:
        guard !state.items.contains(where: { $0.matches(action.filter.matchesRequest) }) else { break }
        state.items.insert(action.filter, at: 0)
        if state.items.count > 20 {
            state.items = Array(state.items.prefix(20))
        }
    case let action as DeleteFilter:
        state.items.removeAll { $0.id == action.id }
    default:
        break
    }
    return state
}

private extension SavedFilter {
    var matchesRequest: PhotoRequest {
        PhotoRequest(rover: rover, camera: camera, date: date)
    }
}
