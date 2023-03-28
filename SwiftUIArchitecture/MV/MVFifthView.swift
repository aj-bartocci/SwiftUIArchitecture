//
//  MVFifthView.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/28/23.
//

import SwiftUI

struct MVFifthView: View {
    @Environment(\.store) var store: MVStore
    @EnvironmentObject var fooState: FooState
    @EnvironmentObject var barState: BarState
    @EnvironmentObject var bazState: BazState
    @EnvironmentObject var fastState: FastUpdatingState
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("Foo: \(fooState.foo)")
            Text("Bar: \(barState.bar)")
            Text("Baz: \(bazState.baz)")
            Button("Update Foo") {
                fooState.foo = "New from fifth View"
            }
            Text("Local count: \(count)")
            Button("Add to local count") {
                count += 1
            }
            Text("Fast update value: \(fastState.fastUpdatingValue)")
            Button("Start heavy updates") {
                store.dispatch(.startFastUpdates)
            }
        }
    }
}
