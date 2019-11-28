//
//  OperationNumber.swift
//  Calculator
//
//  Created by Peter Respondek on 28/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

class OperationNumber : Operation {
    func copy() -> Operation {
        guard let value = _value else { return OperationNumber() }
        return OperationNumber(value)
    }
    
    func collapse() {}
    
    func calculate() -> Double {
        guard let value = _value else { return 0.0 }
        return value
    }
    
    private var _value : Double?
    
    func isEmpty() -> Bool {
        return _value == nil
    }
    func clear() {
        _value = nil
    }
    init() {
        _value = nil
    }
    
    func set(_ value: Operation) {
        _value = value.calculate()
    }
    
    func set(_ value: Double) {
        _value = value
    }
    
    convenience init(_ value: Double) {
        self.init()
        self._value = value
    }
    
    convenience init(_ value: OperationNumber) {
        self.init()
        self._value = value._value
    }
    func add(_ other: Operation) {
        if var value = _value {
            value += other.calculate()
            _value = value
        } else {
            _value = other.calculate()
        }
    }
    func subtract(_ other: Operation) {
        if var value = _value {
            value -= other.calculate()
            _value = value
        } else {
            _value = -other.calculate()
        }
    }
    func multiply(_ other: Operation) {
        if var value = _value {
            value *= other.calculate()
            _value = value
        }
    }
    func divide(_ other: Operation) {
        if var value = _value {
            value /= other.calculate()
            _value = value
        }
    }
}
