//
//  WrappedEnvObject.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/26/23.
//

import SwiftUI

struct WrappedViewOne: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        Content(
            foo: state.foo,
            bar: state.bar,
            baz: state.baz
        )
    }
    
    struct Content: View {
        let foo: String
        let bar: String
        let baz: String
        
        var body: some View {
            VStack {
                Text("Foo: \(foo)")
                Text("Bar: \(bar)")
                Text("Baz: \(baz)")
                Button("Update Foo") {
//                    state.foo = "New from View One"
                }
                NavigationLink("Push View Two") {
                    LazyView(WrappedViewTwo())
                }
            }
        }
    }
}

struct WrappedViewTwo: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        Content(
            foo: state.foo,
            bar: state.bar,
            baz: state.baz
        )
    }
    
    struct Content: View {
        let foo: String
        let bar: String
        let baz: String
        
        var body: some View {
            VStack {
                Text("Foo: \(foo)")
                Text("Bar: \(bar)")
                Text("Baz: \(baz)")
                Button("Update Foo") {
//                    state.foo = "New from View One"
                }
                NavigationLink("Push View Three") {
                    LazyView(WrappedViewThree())
                }
            }
        }
    }
}

struct WrappedViewThree: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        Content(
            foo: state.foo,
            bar: state.bar,
            baz: state.baz
        )
    }
    
    struct Content: View {
        let foo: String
        let bar: String
        let baz: String
        
        var body: some View {
            VStack {
                Text("Foo: \(foo)")
                Text("Bar: \(bar)")
                Text("Baz: \(baz)")
                Button("Update Foo") {
//                    state.foo = "New from View One"
                }
                NavigationLink("Push View Four") {
                    LazyView(WrappedViewFour())
                }
            }
        }
    }
}

struct WrappedViewFour: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        Content(
            foo: state.foo,
            bar: state.bar,
            baz: state.baz
        )
    }
    
    struct Content: View {
        let foo: String
        let bar: String
        let baz: String
        
        var body: some View {
            VStack {
                Text("Foo: \(foo)")
                Text("Bar: \(bar)")
                Text("Baz: \(baz)")
                Button("Update Foo") {
//                    state.foo = "New from View One"
                }
                NavigationLink("Push View Five") {
                    LazyView(WrappedViewFive())
                }
            }
        }
    }
}

struct WrappedViewFive: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        Content(
            foo: state.foo,
            bar: state.bar,
            baz: state.baz,
            fastUpdatingValue: state.fastUpdatingValue,
            startFastUpdates: {
                state.startFastUpdates()
            }
        )
    }
    
    struct Content: View {
        let foo: String
        let bar: String
        let baz: String
        let fastUpdatingValue: Int
        let startFastUpdates: () -> Void
        @State var count = 0
        
        var body: some View {
            VStack {
                Text("Foo: \(foo)")
                Text("Bar: \(bar)")
                Text("Baz: \(baz)")
                Button("Update Foo") {
//                    state.foo = "New from View Four"
                }
                Text("Local count: \(count)")
                Button("Add to local count") {
                    count += 1
                }
                Text("Fast update value: \(fastUpdatingValue)")
                Button("Start heavy updates") {
                    startFastUpdates()
                }
            }
        }
    }
}
