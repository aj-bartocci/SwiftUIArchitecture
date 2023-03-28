//
//  MVFourthView.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/28/23.
//

import SwiftUI

struct MVFourthView: View {
    @EnvironmentObject var fooState: FooState
    @EnvironmentObject var barState: BarState
    @EnvironmentObject var bazState: BazState
    
    var body: some View {
        VStack {
            Text("Foo: \(fooState.foo)")
            Text("Bar: \(barState.bar)")
            Text("Baz: \(bazState.baz)")
            Button("Update Foo") {
                fooState.foo = "New from fourth View"
            }
            NavigationLink("Push Next") {
                LazyView(MVFifthView())
            }
        }
    }
}

