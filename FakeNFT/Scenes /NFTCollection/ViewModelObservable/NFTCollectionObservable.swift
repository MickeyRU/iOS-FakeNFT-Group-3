//
//  NFTCollectionObservable.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 09.09.2023.
//

import Foundation

@propertyWrapper
final class NFTCollectionObservable<Value> {
    private var onChange: ((Value) -> Void)?

    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
        }
    }

    var projectedValue: NFTCollectionObservable<Value> {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(action: @escaping (Value) -> Void) {
        self.onChange = action
    }
}
