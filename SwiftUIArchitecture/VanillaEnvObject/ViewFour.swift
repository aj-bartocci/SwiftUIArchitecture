//
//  ViewFour.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/26/23.
//

import SwiftUI

struct ViewFour: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        VStack {
            Text("Foo: \(state.foo)")
            Text("Bar: \(state.bar)")
            Text("Baz: \(state.baz)")
            Button("Update Foo") {
                state.foo = "New from View Four"
            }
            NavigationLink("Push View Five") {
                LazyView(ViewFive())
            }
        }
    }
}

struct ViewFour_Previews: PreviewProvider {
    static var previews: some View {
        ViewFour()
    }
}
