//
//  ViewFive.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/26/23.
//

import SwiftUI

struct ViewFive: View {
    @EnvironmentObject var state: GlobalStateObject
    @State var count = 0
    
    var body: some View {
        VStack {
            Text("Foo: \(state.foo)")
            Text("Bar: \(state.bar)")
            Text("Baz: \(state.baz)")
            Button("Update Foo") {
                state.foo = "New from View Four"
            }
            Text("Local count: \(count)")
            Button("Add to local count") {
                count += 1
            }
            Text("Fast update value: \(state.fastUpdatingValue)")
            Button("Start heavy updates") {
                state.startFastUpdates()
            }
        }
    }
}

struct ViewFive_Previews: PreviewProvider {
    static var previews: some View {
        ViewFive()
    }
}
