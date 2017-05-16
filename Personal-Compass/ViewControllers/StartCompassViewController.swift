//
//  StartCompassViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/15/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class StartCompassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Personal Compass"

    }
    
    // MARK: -- User Actions
    
    
    @IBAction func menuAction(_ sender: Any) {
        self.sideMenuController?.toggle()
    }

}
