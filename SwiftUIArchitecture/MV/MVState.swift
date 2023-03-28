//
//  MVState.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/28/23.
//

import Combine
import SwiftUI

/*
 With good separation of models MV can be a solid way to do things
 If models remain small and focused this can be quite performant and
 feels very much SwiftUI-like. However, it does have it's drawbacks
 
 Pros:
 - clean interface when using & easy to understand
 - uses the core SwiftUI concepts
 - feels more in line with how Elm does things
 - can easily support a Redux like unidirectional flow
 
 Cons:
 - many objects in the environment which raises exposure to runtime crashes if things are misconfigured
 - without proper separation between objects it can cause lots of unnecessary View refreshes
 - more thought needs to go into state separation boundaries, which may cause refactoring headaches
 
 */

class FooState: ObservableObject {
    @Published var foo = "(initial)"
}

class BarState: ObservableObject {
    @Published var bar = "(initial)"
}

class BazState: ObservableObject {
    @Published var baz = "(initial)"
}

@MainActor
class FastUpdatingState: ObservableObject {
    @Published fileprivate (set) var fastUpdatingValue = 0
    
    fileprivate func startFastUpdates() {
        Task {
            do {
                try await doFastUpdates()
            } catch {
                print("fast updates failed")
            }
        }
    }
    
    private func doFastUpdates() async throws {
        for _ in 0..<1000 {
            // refresh every 1/20th of a second
            try await Task.sleep(nanoseconds: 1_000_000_000/20)
            
            fastUpdatingValue += 1
        }
    }
}

// The root that updates all MV model objects
@MainActor
class MVState {
    let fooState = FooState()
    let barState = BarState()
    let bazState = BazState()
    let fastState = FastUpdatingState()
    
    static var shared = MVState()
}

typealias MVStore = MVState

// Example of supporting a Redux-like flow
extension MVState {
    enum Action {
        case startFastUpdates
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .startFastUpdates:
            fastState.startFastUpdates()
        }
    }
}

enum MVStateKey: EnvironmentKey {
    @MainActor
    static var defaultValue = MVStore()
}

extension EnvironmentValues {
    var store: MVStore {
        get { return self[MVStateKey.self] }
        set { self[MVStateKey.self] = newValue }
    }
}
