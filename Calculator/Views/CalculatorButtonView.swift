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
    }
    
    deinit {
    }
    
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
