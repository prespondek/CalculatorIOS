//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Peter Respondek on 26/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import UIKit

class CalculatorViewController : UIViewController, CalculatorViewModelObserver {
    @IBOutlet var numberbuttons: [CalculatorButtonView]?
    @IBOutlet var operatorbuttons: [CalculatorButtonView]?
    @IBOutlet var modifierButtons: [CalculatorButtonView]?
    @IBOutlet weak var cancelButton: CalculatorButtonView!
    @IBOutlet weak var equalsButton: CalculatorButtonView!
    @IBOutlet weak var outputLabel: UITextField!
    
    lazy var viewModel : CalculatorViewModel = CalculatorViewModel(observer: self)
    
    @objc func numberButtonPressed(_ sender: UIButton) {
        guard let num = sender.titleLabel?.text else { return }
        viewModel.insertCharacter(pos:0, char: num.first ?? "0")
    }
    
    @objc func operatorButtonPressed(_ sender: UIButton) {
        guard let sign = sender.titleLabel?.text else { return }
        viewModel.insertFunction(pos:0, sign: sign.first ?? "0")
    }
    
    @objc func modifierButtonPressed(_ sender: UIButton) {
        guard let sign = sender.titleLabel?.text else { return }
        viewModel.applyModifier(sign: sign.first ?? "0")
    }
    
    @objc func equalsButtonPressed() {
        viewModel.calculate()
    }
    
    @objc func cancelButtonPressed() {
        viewModel.reset()
    }

    override func viewDidLoad() {
    super.viewDidLoad()
        outputLabel.text = "0"
        for button in numberbuttons! {
            button.button.addTarget(self, action: #selector(numberButtonPressed(_:)),
                                    for: .touchUpInside)}
        for button in operatorbuttons! {
            button.button.addTarget(self, action: #selector(operatorButtonPressed(_:)),
                                    for: .touchUpInside)}
        for button in modifierButtons! {
            button.button.addTarget(self, action: #selector(modifierButtonPressed(_:)),
                                    for: .touchUpInside)}
        equalsButton.button.addTarget(self, action: #selector(equalsButtonPressed),
                                      for: .touchUpInside)
        cancelButton.button.addTarget(self, action: #selector(cancelButtonPressed),
                                      for: .touchUpInside)
    }
    
    func calculatorOutput(_ str: String) -> String {
        let str = str
        let old = outputLabel.text
        outputLabel.text = str
        if outputLabel.intrinsicContentSize.width > outputLabel.frame.width {
            if let old = old {
                outputLabel.text = old
            } else {
                outputLabel.text = nil
            }
        }
        return str
    }
    
    func calculatorOutput(_ dec: Decimal) -> String {
        var str = String(describing: dec)
        outputLabel.text = str
        
        // keep adding digit until we fill the screen
        if outputLabel.intrinsicContentSize.width > outputLabel.frame.width {
            var out = "0.E+0"
            var test = str
            repeat {
                str = test
                out.insert("#", at: out.index(out.startIndex, offsetBy: 2))
                let formatter = NumberFormatter()
                formatter.numberStyle = .scientific
                formatter.positiveFormat = out
                formatter.exponentSymbol = "e"
                if let scientificFormatted = formatter.string(for: dec) {
                    test = scientificFormatted
                }
                outputLabel.text = test
            } while outputLabel.intrinsicContentSize.width < outputLabel.frame.width &&
                test != str
        }
        outputLabel.text = str
        return str
    }
}
