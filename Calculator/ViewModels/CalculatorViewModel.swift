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
    func calculatorOutput (_ str: String)
}

/**
 The reason I hold user input as a string rather than a double is because I want the user to be able to modify numbers
 just like you would any normal string input. The fact that modern calculators act like the old analog jobs from school seems archaic.
 This also means I could have complex expressions.
 */
class CalculatorViewModel
{
    var output : String? = nil
    var op = OperationExpression()
    var pendingSign : Character? = nil
    
    weak var observer : CalculatorViewModelObserver?
    
    init (observer: CalculatorViewModelObserver) {
        self.observer = observer
    }
    
    func insertCharacter(pos: Int, char: Character) {
        // ignore "0" when first character is "0"
        if output == nil || output == "0" {
            if (char == "0" && op.isEmpty()) { return }
            else {
                output = String(char)
            }
        } else {
            // ignore "." if there is already a "."
            if ( char == "." && output?.first(where:{$0 == "."}) != nil ) {
                return
            }
            output?.append(char)
        }
        observer?.calculatorOutput(output ?? "0")
    }
    
    func insertFunction(pos: Int, sign: Character) {
        pushOperation()
        output = nil
        pendingSign = sign
        // check if we can safely collapse the operation and show it
        if let sign1 = op.lastSign , let sign2 = pendingSign {
            if OperationExpression.signPriority(sign1) ==
               OperationExpression.signPriority(sign2) {
                printOperation()
            }
        }
    }
    
    func applyModifier(sign: Character, to value: Double) -> Double {
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
        if output == nil && op.isEmpty() == false {
            op.collapse()
            if var value = op.lastNumber {
                value = applyModifier(sign: sign, to: value)
                op.changeLast(op: OperationNumber(value))
                printOperation()
            }
            return
        }
        // We are dealing with user input at this point.
        guard var value = Double(output ?? "0") else {
            assertionFailure("Illegal number formatting")
            return
        }
        value = applyModifier(sign: sign, to: value)
        output = formatNumber(num: value)
        observer?.calculatorOutput(output ?? "0")
    }
    
    func calculate() {
        pushOperation()
        op.collapse()
        printOperation()
        
        pendingSign = nil
        output = nil
    }
    
    func reset() {
        output = nil
        op.clear()
        pendingSign = nil
        observer?.calculatorOutput("0")
    }
    
    func printOperation() {
        let num = op.calculate()
        var str : String
        if num.isNaN { str = "Not a Number" }
        else if num.isInfinite { str = "Infinite" }
        else {
            str = formatNumber(num: num)
        }
        observer?.calculatorOutput(str)
    }
    
    func formatNumber(num: Double) -> String {
        var str = String(num)
        if (str.count > 10) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .scientific
            formatter.positiveFormat = "0.#######E+0"
            formatter.exponentSymbol = "e"
            if let scientificFormatted = formatter.string(for: num) {
                str = scientificFormatted
            }
        } else if (num - floor(num) == 0) {
            str = String(format: "%.0f", num)
        }
        return str
    }
    
    func pushOperation() {
        if op.isEmpty() && output == nil {
            self.output = "0"
        }
        if let output = self.output {
            switch pendingSign {
            case "+": op += Double(output) ?? 0
            case "−": op -= Double(output) ?? 0
            case "×": op *= Double(output) ?? 0
            case "÷": op /= Double(output) ?? 0
            default: op.set(Double(output) ?? 0)
            }
        }
    }
    
}
