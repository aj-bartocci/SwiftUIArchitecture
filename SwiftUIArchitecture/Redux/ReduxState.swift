//
//  ReduxState.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/28/23.
//

import Foundation

struct ReduxState {
    struct FooState {
        var foo = "(initial)"
    }

    struct BarState {
        var bar = "(initial)"
    }

    struct BazState {
        var baz = "(initial)"
    }
    
    struct FastUpdatingState {
        var fastUpdatingValue = 0
    }
    
    var fooState = FooState()
    var barState = BarState()
    var bazState = BazState()
    var fastState = FastUpdatingState()
}
