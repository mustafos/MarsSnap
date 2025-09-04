//
//  Store.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 17.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Combine
import Foundation

typealias Dispatcher = (Action) -> Void
typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State
typealias Middleware<StoreState: ReduxState> = (StoreState, Action, @escaping Dispatcher) -> Void

protocol ReduxState { }

struct AppState: ReduxState {
    var photos = PhotosState()
    var filters = FiltersState()
    var history = HistoryState()
}

struct PhotosState: ReduxState {
    var photos = [Photo]()
    var isLoading = false
    var isLoadingMore = false
    var errorMessage: String?
    var page = 1
    var hasMore = false
    var query = ""
    var requestID = UUID()
}

struct FiltersState: ReduxState {
    var rover: String = Rover.curiosity.rawValue
    var camera: String?
    var date: String?
    var camerasByRover: [String: [RoverCamera]] = [:]

    var request: PhotoRequest {
        PhotoRequest(rover: rover, camera: camera, date: date)
    }
}

struct HistoryState: ReduxState {
    var items: [SavedFilter] = []
}

protocol Action { }

struct FetchPhotos: Action {
    let request: PhotoRequest
    let page: Int
    let requestID: UUID
}

struct PhotosLoaded: Action {
    let requestID: UUID
    let page: Int
    let photos: [Photo]
    let hasMore: Bool
}

struct PhotosFailed: Action {
    let requestID: UUID
    let page: Int
    let message: String
}

struct ClearPhotoError: Action { }

struct SetFilters: Action {
    let request: PhotoRequest
}

struct SetRoverCameras: Action {
    let rover: String
    let cameras: [RoverCamera]
}

struct LoadHistory: Action { }

struct SetHistory: Action {
    let items: [SavedFilter]
}

struct AddFilter: Action {
    let filter: SavedFilter
}

struct DeleteFilter: Action {
    let id: UUID
}

class Store<StoreState: ReduxState>: ObservableObject {
    var reducer: Reducer<StoreState>
    @Published var state: StoreState
    var middlewares: [Middleware<StoreState>]

    init(
        reducer: @escaping Reducer<StoreState>,
        state: StoreState,
        middlewares: [Middleware<StoreState>] = []
    ) {
        self.reducer = reducer
        self.state = state
        self.middlewares = middlewares
    }

    func dispatch(action: Action) {
        let apply = {
            self.state = self.reducer(self.state, action)
            self.middlewares.forEach { middleware in
                middleware(self.state, action, self.dispatch)
            }
        }

        if Thread.isMainThread {
            apply()
        } else {
            DispatchQueue.main.async(execute: apply)
        }
    }
}
