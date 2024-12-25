//
//  Store.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 17.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

typealias Dispatcher = (Action) -> Void

typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State
typealias Middlewere<StoreState: ReduxState> = (StoreState, Action, @escaping Dispatcher) -> Void

protocol ReduxState { }

struct AppState: ReduxState {
    var photos = PhotosState()
}

struct PhotosState: ReduxState {
    var photos = [Photo]()
}

protocol Action { }

struct FetchPhotos: Action {
    let rover: String
    let camera: String?
    let date: String?
}

struct SetPhotos: Action {
    let photos: [Photo]
}

class Store<StoreState: ReduxState>: ObservableObject {
    
    var reducer: Reducer<StoreState>
    @Published var state: StoreState
    var middlewares: [Middlewere<StoreState>]
    
    init(reducer: @escaping Reducer<StoreState>, state: StoreState, middlewares: [Middlewere<StoreState>] = []) {
        self.reducer = reducer
        self.state = state
        self.middlewares = middlewares
    }
    
    func dispatch(action: Action) {
        DispatchQueue.main.async {
            self.state = self.reducer(self.state, action)
        }
        
        // run all middlewares
        middlewares.forEach { middlewares in
            middlewares(state, action, dispatch)
        }
    }
}
