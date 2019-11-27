//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Peter Respondek on 26/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import UIKit

class CalculatorViewController : UIViewController {
    @IBOutlet var numberbuttons: [CalculatorButtonView]?
    @IBOutlet var operatorbuttons: [CalculatorButtonView]?
    @IBOutlet weak var cancelButton: CalculatorButtonView!
    @IBOutlet weak var equalsButton: CalculatorButtonView!
    @IBOutlet weak var outputLabel: UILabel!
    
    var output : String? = nil
    var op = Operation()
    var pendingSign : Character? = nil
    
    @objc func numberButtonPressed(_ sender: UIButton) {
        guard let num = sender.titleLabel?.text else { return }
    
        if output == nil || output == "0" {
            if (num == "0" && op.isEmpty) { return }
            else {
                output = num
            }
        } else {
            output?.append(num)
        }
        outputLabel.text = output
        if outputLabel.isTruncated == true {
            output?.removeLast()
            outputLabel.text = output
        }
    }
    @objc func operatorButtonPressed(_ sender: UIButton) {
        guard var sign = sender.titleLabel?.text else {
            assert(false, "invalid operator sign")
            return }
        pushOperation()
        output = nil
        pendingSign = sign.popLast() ?? pendingSign
        // check if we can safely collapse the operation and show it
        if let sign1 = op.lastSign , let sign2 = pendingSign {
            if Operation.signPriority(sign1) ==
               Operation.signPriority(sign2) {
                printOperation()
            }
        }
    }
    
    @objc func equalsButtonPressed() {
        pushOperation()
        op.collapse()
        printOperation()
        
        pendingSign = nil
        output = String(op.value)
    }
    
    @objc func cancelButtonPressed() {
        output = nil
        op.clear()
        pendingSign = nil
        outputLabel.text = "0"
    }
    
    func pushOperation() {
        let output = self.output ?? "0"
        switch pendingSign {
            case "+": op += Double(output) ?? 0
            case "−": op -= Double(output) ?? 0
            case "×": op *= Double(output) ?? 0
            case "÷": op /= Double(output) ?? 0
            default: op.set(Double(output) ?? 0)
        }
        
    }

    
    func printOperation() {
        let num = op.calculate
        var str : String
        if num.isNaN { str = "Not a Number" }
        else if num.isInfinite { str = "Infinite" }
        else {
            str = String(num)
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
        }
        outputLabel.text = str
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        // hooking up button callbacks
        for button in numberbuttons! {
            button.button.addTarget(self, action: #selector(numberButtonPressed(_:)), for: .touchUpInside)
        }
        for button in operatorbuttons! {
            button.button.addTarget(self, action: #selector(operatorButtonPressed(_:)), for: .touchUpInside)
        }
        equalsButton.button.addTarget(self, action: #selector(equalsButtonPressed), for: .touchUpInside)
        cancelButton.button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    }
}
