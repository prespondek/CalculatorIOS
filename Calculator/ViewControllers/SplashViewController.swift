//
//  SplashViewController.swift
//  Calculator
//
//  Created by Peter Respondek on 26/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import UIKit

class SplashViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        var time = 3.0
        if ProcessInfo.processInfo.arguments.contains("--testing") {
            time = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.performSegue( withIdentifier: "SplashSerge", sender: self)
        }
    }
}


