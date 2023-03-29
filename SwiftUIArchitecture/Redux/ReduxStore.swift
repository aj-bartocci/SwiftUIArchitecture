//
//  ReduxStore.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/28/23.
//

import Foundation

/*
 Simplified example. A full redux implementation would have
 reducers and whatnot
 
 */

@MainActor
class ReduxStore: ObservableObject {
    @Published private (set) var state = ReduxState()
    
    enum Action {
        case startFastUpdates
        case updateFoo(to: String)
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .startFastUpdates:
            startFastUpdates()
        case .updateFoo(to: let newFoo):
            state.fooState.foo = newFoo
        }
    }
}

private extension ReduxStore {
    
    func startFastUpdates() {
        Task {
            do {
                for _ in 0..<1000 {
                    // refresh every 1/20th of a second
                    try await Task.sleep(nanoseconds: 1_000_000_000/20)
                    
                    state.fastState.fastUpdatingValue += 1
                }
            } catch {
                print("fast updates failed")
            }
        }
    }
}
