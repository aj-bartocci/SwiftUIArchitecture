//
//  MobXTwoView.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/28/23.
//

import SwiftUI
import Combine

@MainActor
class MVVMSecondViewModel: ObservableObject {
    private let state: GlobalStateObject
    @Published private (set) var fooText: String = ""
    @Published private (set) var barText: String = ""
    @Published private (set) var bazText: String = ""
    
    init(state: GlobalStateObject) {
        self.state = state
        
        state.$foo
            .map({
                return "Foo: \($0)"
            })
            .assign(to: &$fooText)
        
        state.$bar
            .map({
                return "Bar: \($0)"
            })
            .assign(to: &$barText)
        
        state.$baz
            .map({
                return "Baz: \($0)"
            })
            .assign(to: &$bazText)
    }
    
    func updateFoo(to newValue: String) {
        state.foo = newValue
    }
    
    func updateValueViewDoesNotCareAbout() {
        state.fastUpdatingValue += 1
    }
}

struct MVVMSecondView: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        Content(state: state)
    }
    
    struct Content: View {
        @StateObject var viewModel: MVVMSecondViewModel
        
        init(state: GlobalStateObject) {
            self._viewModel = StateObject(wrappedValue: MVVMSecondViewModel(state: state))
        }
        
        var body: some View {
            VStack {
                Text(viewModel.fooText)
                Text(viewModel.barText)
                Text(viewModel.bazText)
                Button("Update Foo") {
                    viewModel.updateFoo(to: "New from second View")
                }
                Button("Update FastUpdatingValue") {
                    viewModel.updateValueViewDoesNotCareAbout()
                }
                NavigationLink("Push Next") {
                    LazyView(MVVMThirdView())
                }
            }
        }
    }
}
