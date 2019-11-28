//
//  Operation.swift
//  Calculator
//
//  Created by Peter Respondek on 27/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

/**
 An individual "Operation" could be a complex expression or just a simple number. 
*/
protocol Operation {
    
    func isEmpty() -> Bool
    func collapse()
    func clear()
    func set(_ value: Operation)
    func set(_ value: Double)
    func calculate() -> Double
    func add(_ other: Operation)
    func subtract(_ other: Operation)
    func multiply(_ other: Operation)
    func divide(_ other: Operation)
    func copy() -> Operation
}
