//
//  MVThirdView.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/28/23.
//

import SwiftUI

struct MVThirdView: View {
    @EnvironmentObject var fooState: FooState
    @EnvironmentObject var barState: BarState
    @EnvironmentObject var bazState: BazState
    
    var body: some View {
        VStack {
            Text("Foo: \(fooState.foo)")
            Text("Bar: \(barState.bar)")
            Text("Baz: \(bazState.baz)")
            Button("Update Foo") {
                fooState.foo = "New from third View"
            }
            NavigationLink("Push Next") {
                LazyView(MVFourthView())
            }
        }
    }
}
