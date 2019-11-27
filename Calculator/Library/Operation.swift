//
//  Operation.swift
//  Calculator
//
//  Created by Peter Respondek on 27/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

// This takes care of order of operation. Also could be easily expanded to allow brakets ().
// An individual "Operation" could be a complex expression or just a simple number.

class Operation {
    private var operators : Array<Character>
    private var operands : Array<Operation>
    private var _value : Double?
    var lastSign : Character? {
        return operators.last
    }
    var isEmpty : Bool {
        return operators.isEmpty && operands.isEmpty && _value == 0
    }
    var value : Double {
        get {
            if (_value == nil) {
                return calculate
            }
            return _value!
        }
    }
    
    init() {
        operators = Array<Character>()
        operands = Array<Operation>()
        _value = nil
    }
    
    convenience init(_ value: Double) {
        self.init()
        self._value = value
    }
    
    // copy construtor
    convenience init(_ value: Operation) {
        self.init()
        self._value = value._value
        self.operators = value.operators
        for operand in value.operands {
            self.operands.append(Operation(operand))
        }
    }
    
    // calculates the operations value and clears the expression.
    func collapse() {
        if (_value == nil) {
            _value = calculate
            operands.removeAll()
            operators.removeAll()
        }
    }
    func clear() {
        operands.removeAll()
        operators.removeAll()
        _value = nil
    }
    
    func set(_ value: Double) {
        clear()
        operands.append(Operation(value))
    }
    
    private func appendOperation(sign: Character, other: Operation) {
        if let value = _value {
            operands.append(Operation(value))
            _value = nil
        }
        operators.append(sign)
        operands.append(other)
    }
    
    static func -=(_ left: inout Operation,_ right: Double) {
        left -= Operation(right)
    }
    static func -=(_ left: inout Operation,_ right: Operation) {
        left.appendOperation(sign: "−", other: right)
    }
    static func +=(_ left: inout Operation,_ right: Double) {
        left += Operation(right)
    }
    static func +=(_ left: inout Operation,_ right: Operation) {
        left.appendOperation(sign: "+", other: right)
    }
    static func *=(_ left: inout Operation,_ right: Double) {
        left *= Operation(right)
    }
    static func *=(_ left: inout Operation,_ right: Operation) {
        left.appendOperation(sign: "×", other: right)
    }
    static func /=(_ left: inout Operation,_ right: Double) {
        left /= Operation(right)
    }
    static func /=(_ left: inout Operation,_ right: Operation) {
        left.appendOperation(sign: "÷", other: right)
    }
    
    private func collapseOperation(priority: Int) {
        var i = 0
        while i != operators.count {
            if Operation.signPriority(operators[i]) == priority {
                operands.insert(
                    Operation(signFunc(operators[i])(operands[i].value,
                                                     operands[i+1].value)), at: i)
                operands.remove(at: i+1)
                operands.remove(at: i+1)
                operators.remove(at: i)
            } else {
                i+=1
            }
        }
    }
    
    var calculate : Double {
        if operands.count == 0 { return value }
        
        // order of operations. Collaspe the multiply and divides first.
        let out = Operation(self)
        out.collapseOperation(priority: 1)
        out.collapseOperation(priority: 2)
        guard let value = out.operands[0]._value else { return 0.0 }
        return value
    }
    
    static func signPriority(_ sign: Character) -> Int {
        switch sign {
        case "×": return 2
        case "÷": return 2
        case "+": return 1
        case "−": return 1
        default: return 0
        }
    }
    func signFunc(_ sign: Character) -> (Double,Double)->Double{
        switch sign {
        case "×": return { return $0*$1 }
        case "÷": return { return $0/$1 }
        case "+": return { return $0+$1 }
        case "−": return { return $0-$1 }
        default: return { _,_ in return 0 }
        }
    }
}
