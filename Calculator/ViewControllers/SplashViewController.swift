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
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
        self.performSegue( withIdentifier: "SplashSerge", sender: self)
    }
    }
}


