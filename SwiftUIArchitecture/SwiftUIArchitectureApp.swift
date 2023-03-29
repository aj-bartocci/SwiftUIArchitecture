//
//  SwiftUIArchitectureApp.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/24/23.
//

import SwiftUI

struct LazyView<Content: View>: View {
    private let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: some View {
        build()
    }
}

class EnvObjTest: ObservableObject {
    @Published var test = "foo"
    
    init(test: String = "foo") {
        self.test = test
    }
}

//struct GlobalContextStateKey: GlobalContextKey {
//    static var defaultValue = GlobalStateObject(
//        foo: "(Global)",
//        bar: "(Global)",
//        fastUpdatingValue: 0
//    )
//}
//
//extension GlobalContextValues {
//    var state: GlobalStateObject {
//        get { return self.getValue(for: GlobalContextStateKey.self) }
//        set { self.setValue(newValue, for: GlobalContextStateKey.self) }
//    }
//}

@main
struct SwiftUIArchitectureApp: App {
    @StateObject var state = GlobalStateObject()
    @Environment(\.store) var store: MVState
    @StateObject var reduxStore = ReduxStore()
//    @State var state = GlobalStateObject(
//        foo: "(App root)",
//        bar: "(App root)",
//        fastUpdatingValue: 0
//    )
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    Text("Foo: \(state.foo)")
                    NavigationLink("Push View One") {
                        LazyView(
                            ViewOne()
                        )
                    }
                    NavigationLink("Push Wrapped View One") {
                        LazyView(
                            WrappedViewOne()
                        )
                    }
                    NavigationLink("Push MVVM Stack") {
                        LazyView(
                            MVVMFirstView()
                        )
                    }
                    NavigationLink("Push MV Stack") {
                        LazyView(
                            MVFirstView()
                        )
                    }
                    NavigationLink("Push Redux Stack") {
                        LazyView(
                            ReduxFirstView()
                        )
                    }
                }
            }
            .navigationViewStyle(.stack)
            .environmentObject(state)
            .environmentObject(store.fooState)
            .environmentObject(store.barState)
            .environmentObject(store.bazState)
            .environmentObject(store.fastState)
            .environmentObject(reduxStore)
        }
    }
}
