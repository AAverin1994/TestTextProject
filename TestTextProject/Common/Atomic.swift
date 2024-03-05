//
//  Atomic.swift
//  TestTextProject
//
//  Created by Andrey on 05.03.2024.
//

import Foundation

final class AtomicValue<T> {
    private let lock = NSRecursiveLock()

    init(_ value: T) {
        self._value = value
    }

    var value: T {
        get {
            return _value
        }
        set {
            lock.lock()
            _value = newValue
            lock.unlock()
        }
    }

    private var _value: T
}

final class AtomicBuffer<T> {
    private let lock = NSRecursiveLock()
    private(set) var values: [T] = [T]()

    func append(_ value: T) {
        lock.lock()
        values.append(value)
        lock.unlock()
    }

    func clear() {
        values.removeAll()
    }
}
