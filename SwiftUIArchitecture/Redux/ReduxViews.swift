//
//  ReduxViews.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/28/23.
//

import SwiftUI

struct ReduxFirstView: View {
    @EnvironmentObject var store: ReduxStore
    
    var body: some View {
        VStack {
            Text("Foo: \(store.state.fooState.foo)")
            Text("Bar: \(store.state.barState.bar)")
            Text("Baz: \(store.state.bazState.baz)")
            Button("Update Foo") {
                store.dispatch(.updateFoo(to: "New from first View"))
            }
            NavigationLink("Push Next") {
                LazyView(ReduxSecondView())
            }
        }
    }
}

struct ReduxSecondView: View {
    @EnvironmentObject var store: ReduxStore
    
    var body: some View {
        VStack {
            Text("Foo: \(store.state.fooState.foo)")
            Text("Bar: \(store.state.barState.bar)")
            Text("Baz: \(store.state.bazState.baz)")
            Button("Update Foo") {
                store.dispatch(.updateFoo(to: "New from second View"))
            }
            NavigationLink("Push Next") {
                LazyView(ReduxThirdView())
            }
        }
    }
}

struct ReduxThirdView: View {
    @EnvironmentObject var store: ReduxStore
    
    var body: some View {
        VStack {
            Text("Foo: \(store.state.fooState.foo)")
            Text("Bar: \(store.state.barState.bar)")
            Text("Baz: \(store.state.bazState.baz)")
            Button("Update Foo") {
                store.dispatch(.updateFoo(to: "New from third View"))
            }
            NavigationLink("Push Next") {
                LazyView(ReduxFourthView())
            }
        }
    }
}

struct ReduxFourthView: View {
    @EnvironmentObject var store: ReduxStore
    
    var body: some View {
        VStack {
            Text("Foo: \(store.state.fooState.foo)")
            Text("Bar: \(store.state.barState.bar)")
            Text("Baz: \(store.state.bazState.baz)")
            Button("Update Foo") {
                store.dispatch(.updateFoo(to: "New from fourth View"))
            }
            NavigationLink("Push Next") {
                LazyView(ReduxFifthView())
            }
        }
    }
}

struct ReduxFifthView: View {
    @EnvironmentObject var store: ReduxStore
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("Foo: \(store.state.fooState.foo)")
            Text("Bar: \(store.state.barState.bar)")
            Text("Baz: \(store.state.bazState.baz)")
            Button("Update Foo") {
                store.dispatch(.updateFoo(to: "New from fifth View"))
            }
            Text("Local count: \(count)")
            Button("Add to local count") {
                count += 1
            }
            Text("Fast update value: \(store.state.fastState.fastUpdatingValue)")
            Button("Start heavy updates") {
                store.dispatch(.startFastUpdates)
            }
        }
    }
}
