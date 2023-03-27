//
//  StateObject.swift
//  SwiftUIArchitecture
//
//  Created by AJ Bartocci on 3/26/23.
//

import Foundation

@MainActor
class GlobalStateObject: ObservableObject {
    @Published var foo: String
    @Published var bar: String
    @Published var baz: String
    @Published var fastUpdatingValue: Int
    
    init(
        foo: String = "Foo (initial)",
        bar: String = "Bar (initial)",
        baz: String = "Baz (initial)",
        fastUpdatingValue: Int = 0
    ) {
        self.foo = foo
        self.bar = bar
        self.baz = baz
        self.fastUpdatingValue = fastUpdatingValue
    }
    
    deinit {
        print("Global state deinit")
    }
    
    func startFastUpdates() {
        Task {
            do {
                try await doFastUpdates()
            } catch {
                print("fast updates failed")
            }
        }
    }
    
    private func doFastUpdates() async throws {
        for _ in 0..<1000 {
            try await Task.sleep(nanoseconds: 1_000_000_000/20)
            
            fastUpdatingValue += 1
        }
    }
}
