//
//  ViewOne.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/26/23.
//

import SwiftUI

//struct Injected


struct ViewOne: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        VStack {
            Text("Foo: \(state.foo)")
            Text("Bar: \(state.bar)")
            Text("Baz: \(state.baz)")
            Button("Update Foo") {
                state.foo = "New from View One"
            }
            NavigationLink("Push View Two") {
                LazyView(ViewTwo())
            }
        }
    }
}

struct ViewOne_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ViewOne()
                .previewDisplayName("View One - 1")
            
            ViewOne()
                .previewDisplayName("View One - 2")
            
            ViewOne()
                .previewDisplayName("View One - 3")
        }
    }
}
