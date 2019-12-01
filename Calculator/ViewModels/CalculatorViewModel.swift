//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Peter Respondek on 30/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

/**
 I use mvvm because it intergrates with android better
 */

protocol CalculatorViewModelObserver : class {
    func calculatorOutput (_ str: String) -> String
    func calculatorOutput (_ dec: Decimal) -> String
}

/**
 The reason I hold user input as a string rather than a decimal is because I want the user to be able to modify numbers
 just like you would any normal string input. The fact that modern calculators act like the old analog jobs from school seems archaic.
 This also means I could have complex expressions.
 */
class CalculatorViewModel
{
    var output : String? = nil
    var expression = OperationExpression()
    var pendingSign : Character? = nil
    
    weak var observer : CalculatorViewModelObserver?
    
    init (observer: CalculatorViewModelObserver) {
        self.observer = observer
    }
    
    func insertCharacter(pos: Int, char: Character) {
        // ignore "0" when first character is "0"
        if output == nil || output == "0" {
            if (char == "0" && expression.isEmpty()) { return }
            else if ( char == "." ) {
                output = String("0.")
            }
            else {
                output = String(char)
            }
        } else {
            if ( char == "." ) {
                if ( output?.first(where:{$0 == "."}) != nil ) { return }
            }
            output?.append(char)
        }
        output = observer?.calculatorOutput(output ?? "0")
    }
    
    func insertFunction(pos: Int, sign: Character) {
        pushOperation()
        output = nil
        pendingSign = sign
        // check if we can safely collapse the operation and show it
        if let sign1 = expression.lastSign , let sign2 = pendingSign {
            if OperationExpression.signPriority(sign1) ==
               OperationExpression.signPriority(sign2) {
                printOperation()
            }
        }
    }
    
    func applyModifier(sign: Character, to value: Decimal) -> Decimal {
        var value = value
        switch sign {
        case "%": value /= 100.0
        case "±": value = -value
        default:
            assertionFailure("Illegal modifier character")
            return 0.0
        }
        return value
    }
    
    func applyModifier(sign: Character) {
        // in order to not loose precision of our Double apply the modifier to the last operation
        if output == nil && expression.isEmpty() == false {
            expression.collapse()
            if var value = expression.lastNumber {
                value = applyModifier(sign: sign, to: value)
                expression.changeLast(op: OperationNumber(value))
                printOperation()
            }
            return
        }
        // We are dealing with user input at this point.
        guard var value = Decimal(string: output ?? "0") else {
            assertionFailure("Illegal number formatting")
            return
        }
        value = applyModifier(sign: sign, to: value)
        output = String(describing: value)
        _ = observer?.calculatorOutput(output ?? "0")
    }
    
    func calculate() {
        pushOperation()
        expression.collapse()
        printOperation()
        
        pendingSign = nil
        output = nil
    }
    
    func reset() {
        output = nil
        expression.clear()
        pendingSign = nil
        _ = observer?.calculatorOutput("0")
    }
    
    func printOperation() {
        let num = expression.calculate()
        var str : String?
        if num.isNaN { str = "Not a Number" }
        else if num.isInfinite { str = "Infinite" }
        if let str = str {
            _ = observer?.calculatorOutput(str)
        } else {
            _ = observer?.calculatorOutput(num)
        }
        
    }
    
    func pushOperation() {
        if expression.isEmpty() && output == nil {
            self.output = "0"
        }
        if let output = self.output {
            switch pendingSign {
            case "+": expression += Decimal(string: output) ?? 0
            case "−": expression -= Decimal(string: output) ?? 0
            case "×": expression *= Decimal(string: output) ?? 0
            case "÷": expression /= Decimal(string: output) ?? 0
            default: expression.set(Decimal(string: output) ?? 0)
            }
        }
    }
    
}
