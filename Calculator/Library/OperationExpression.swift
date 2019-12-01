//
//  OperationExpression.swift
//  Calculator
//
//  Created by Peter Respondek on 28/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

/**
 An conplex math expression
 This takes care of order of operation. Also could be easily expanded to allow brakets ().
 */
class OperationExpression : Operation {
    private var operators : Array<Character>
    private var operands : Array<Operation>
    var lastSign : Character? {
        return operators.last
    }
    var lastNumber : Decimal? {
        return operands.last?.calculate()
    }
    func changeLast(op: Operation) {
        _ = operands.popLast()
        operands.append(op)
    }
    func isEmpty() -> Bool {
        return operators.isEmpty && operands.isEmpty
    }
    init() {
        operators = Array<Character>()
        operands = Array<Operation>()
    }
    
    convenience init(_ value: OperationExpression) {
        self.init()
        self.operators = value.operators
        for operand in value.operands {
            self.operands.append(operand.copy())
        }
    }
    
    func copy() -> Operation {
        let new = OperationExpression()
        new.operators = operators
        for i in operands {
            new.operands.append(i.copy())
        }
        return new
    }
    
    func set(_ value: Operation) {
        clear()
        operands.append(value)
    }
    
    func set(_ value: Decimal) {
        clear()
        operands.append(OperationNumber(value))
    }
    func clear() {
        operands.removeAll()
        operators.removeAll()
    }
    
    func calculate() -> Decimal {
        if operands.count == 0 { return 0 }
        // order of operations. Collaspe the multiply and divides first.
        let out = OperationExpression(self)
        out.collapseOperation(priority: 2)
        out.collapseOperation(priority: 1)
        return out.operands[0].calculate()
    }
    
    func collapse() {
        let value = calculate()
        operands.removeAll()
        operators.removeAll()
        operands.append(OperationNumber(value))
    }
    
    private func collapseOperation(priority: Int) {
        var i = 0
        while i != operators.count {
            if OperationExpression.signPriority(operators[i]) == priority {
                operands.insert(
                    OperationNumber(signFunc(operators[i])(operands[i].calculate(),
                                                     operands[i+1].calculate())), at: i)
                operands.remove(at: i+1)
                operands.remove(at: i+1)
                operators.remove(at: i)
            } else {
                i+=1
            }
        }
    }
    
    private func appendOperation(sign: Character, other: Operation) {
        operators.append(sign)
        operands.append(other)
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
    func signFunc(_ sign: Character) -> (Decimal,Decimal)->Decimal{
        switch sign {
        case "×": return { return $0*$1 }
        case "÷": return { return $0/$1 }
        case "+": return { return $0+$1 }
        case "−": return { return $0-$1 }
        default: return { _,_ in return 0 }
        }
    }
    func add(_ other: Operation) {
        appendOperation(sign: "+", other: other)
    }
    func subtract(_ other: Operation) {
        appendOperation(sign: "−", other: other)
    }
    func multiply(_ other: Operation) {
        appendOperation(sign: "×", other: other)
    }
    func divide(_ other: Operation) {
        appendOperation(sign: "÷", other: other)
    }
    
    static func -=(_ left: inout OperationExpression,_ right: Decimal) {
        left -= OperationNumber(right)
    }
    static func -=(_ left: inout OperationExpression,_ right: Operation) {
        left.subtract(right)
    }
    static func +=(_ left: inout OperationExpression,_ right: Decimal) {
        left += OperationNumber(right)
    }
    static func +=(_ left: inout OperationExpression,_ right: Operation) {
        left.add(right)
    }
    static func *=(_ left: inout OperationExpression,_ right: Decimal) {
        left *= OperationNumber(right)
    }
    static func *=(_ left: inout OperationExpression,_ right: Operation) {
        left.multiply(right)
    }
    static func /=(_ left: inout OperationExpression,_ right: Decimal) {
        left /= OperationNumber(right)
    }
    static func /=(_ left: inout OperationExpression,_ right: Operation) {
        left.divide(right)
    }

}
