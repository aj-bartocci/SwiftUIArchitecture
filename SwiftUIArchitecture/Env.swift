//
//  Env.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/24/23.
//

import SwiftUI

class GlobalState: ObservableObject {
    @Published var username = "Starting username"
}

class GlobalStore {
    let state = GlobalState()
}

struct GlobalStoreKey: EnvironmentKey {
    static var defaultValue = GlobalStore()
}

extension EnvironmentValues {
    var globalStore: GlobalStore {
        get { self[GlobalStoreKey.self] }
        set { self[GlobalStoreKey.self] = newValue }
    }
}
