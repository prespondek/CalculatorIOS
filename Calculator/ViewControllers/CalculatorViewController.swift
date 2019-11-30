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
    @IBOutlet var modifierButtons:
        [CalculatorButtonView]?
    @IBOutlet weak var cancelButton: CalculatorButtonView!
    @IBOutlet weak var equalsButton: CalculatorButtonView!
    @IBOutlet weak var outputLabel: UILabel!
    
    lazy var viewModel : CalculatorViewModel = CalculatorViewModel(observer: self)
    
    func calculatorOutput(_ str: String) {
        self.outputLabel.text = str
        if outputLabel.isTruncated == true {
            //output?.removeLast()
        }
    }
    
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
        for button in numberbuttons! {
            button.button.addTarget(self, action: #selector(numberButtonPressed(_:)),
                                    for: .touchUpInside)
        }
        for button in operatorbuttons! {
            button.button.addTarget(self, action: #selector(operatorButtonPressed(_:)),
                                    for: .touchUpInside)
        }
        for button in modifierButtons! {
            button.button.addTarget(self, action: #selector(modifierButtonPressed(_:)),
                                    for: .touchUpInside)
        }
        equalsButton.button.addTarget(self, action: #selector(equalsButtonPressed),
                                      for: .touchUpInside)
        cancelButton.button.addTarget(self, action: #selector(cancelButtonPressed),
                                      for: .touchUpInside)
        
    }
}
