//
//  StoreWrapper.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/25.
//

import Foundation
import SwiftUI
import Combine

@propertyWrapper
struct Store<Model>: DynamicProperty {

    @dynamicMemberLookup
    struct Wrapper {
        fileprivate var store: Store
        subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Model, Value>) -> Binding<Value> {
            Binding(get: { self.store.wrappedValue[keyPath: keyPath] },
                    set: { self.store.wrappedValue[keyPath: keyPath] = $0 })
        }
    }
    var projectedValue: Wrapper {
        Wrapper(store: self)
    }
    
    private class ErasedObservableObject: ObservableObject {
        let objectWillChange: AnyPublisher<Void, Never>

        init(objectWillChange: AnyPublisher<Void, Never>) {
            self.objectWillChange = objectWillChange
        }
    }

    let wrappedValue: Model
    
    @ObservedObject
    private var observableObject: ErasedObservableObject

    init(wrappedValue: Model) {
        self.wrappedValue = wrappedValue

        if let objectWillChange = (wrappedValue as? AnyObservableObject)?.objectWillChange {
            self.observableObject = .init(objectWillChange: objectWillChange.eraseToAnyPublisher())
        } else {
            assertionFailure("Only use the `Store` property wrapper with instances conforming to `AnyObservableObject`.")
            self.observableObject = .init(objectWillChange: Empty().eraseToAnyPublisher())
        }
    }
}

protocol AnyObservableObject: AnyObject {
    var objectWillChange: ObservableObjectPublisher { get }
}
