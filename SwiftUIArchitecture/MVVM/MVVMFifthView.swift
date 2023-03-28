//
//  MobXFifthView.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/28/23.
//

import SwiftUI
import Combine

@MainActor
class MVVMFifthViewModel: ObservableObject {
    private let state: GlobalStateObject
    @Published private (set) var fooText: String = ""
    @Published private (set) var barText: String = ""
    @Published private (set) var bazText: String = ""
    @Published private (set) var fastUpdatingText = ""
    @Published private (set) var countText: String = ""
    
    @Published var count = 0
    
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
        
        state.$fastUpdatingValue
            .map({
                return "Fast updating value: \($0)"
            })
            .assign(to: &$fastUpdatingText)
        
        $count
            .map({
                return "Local count: \($0)"
            })
            .assign(to: &$countText)
    }
    
    func updateFoo(to newValue: String) {
        state.foo = newValue
    }
    
    func updateValueViewDoesNotCareAbout() {
        state.fastUpdatingValue += 1
    }
    
    func startFastUpdates() {
        state.startFastUpdates()
    }
}

struct MVVMFifthView: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        Content(state: state)
    }
    
    struct Content: View {
        @StateObject var viewModel: MVVMFifthViewModel
        
        init(state: GlobalStateObject) {
            self._viewModel = StateObject(wrappedValue: MVVMFifthViewModel(state: state))
        }
        
        var body: some View {
            VStack {
                Text(viewModel.fooText)
                Text(viewModel.barText)
                Text(viewModel.bazText)
                Button("Update Foo") {
                    viewModel.updateFoo(to: "New from fifth View")
                }
                Text(viewModel.countText)
                Button("Add to local count") {
                    viewModel.count += 1
                }
                Text(viewModel.fastUpdatingText)
                Button("Start heavy updates") {
                    viewModel.startFastUpdates()
                }
            }
        }
    }
}
