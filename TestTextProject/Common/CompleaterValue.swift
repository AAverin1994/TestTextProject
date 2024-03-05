//
//  CompleaterValue.swift
//  TestTextProject
//
//  Created by Andrey on 05.03.2024.
//

import Foundation

final class CompleaterValue {
    private let _value: AtomicValue<Int>
    private var completion: () -> Void

    init(value: Int, completion: @escaping () -> Void) {
        self._value = .init(value)
        self.completion = completion
    }

    var value: Int {
        get {
            return _value.value
        }
        set {
            if newValue <= 0 {
                completion()
                _value.value = 0
            } else {
                _value.value = newValue
            }
        }
    }
}
