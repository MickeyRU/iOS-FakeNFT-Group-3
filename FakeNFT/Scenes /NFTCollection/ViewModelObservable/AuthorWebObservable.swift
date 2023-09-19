//
//  AuthorWebViewObservable.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 12.09.2023.
//

import Foundation

@propertyWrapper
final class AuthorWebObservable<Value> {
    private var onChange: ((Value) -> Void)?

    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
        }
    }

    var projectedValue: AuthorWebObservable<Value> {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(action: @escaping (Value) -> Void) {
        self.onChange = action
    }
}
