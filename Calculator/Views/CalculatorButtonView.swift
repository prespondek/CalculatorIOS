//
//  CalculatorButtonView.swift
//  Calculator
//
//  Created by Peter Respondek on 26/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

import Foundation
import UIKit

@IBDesignable
class CalculatorButtonView : UIView {
    @IBInspectable var text : String = "" {
        didSet { updateLabel(string: text) }
    }
    @IBInspectable var normalColor : UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet { button.updateColor(color: normalColor, state: .normal) }
    }
    
    func updateLabel(string: String) {
        button.setTitle(string, for: UIControl.State.normal)
    }
    
    @IBOutlet weak var button: StrokedButton!
    var contentView:UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        
    }
    
    func setup() {
        loadNib()
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.minimumScaleFactor = 0.5
    }
    
    deinit { }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Button", bundle: bundle)
        let view = nib.instantiate(
            withOwner: self,
            options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
}
