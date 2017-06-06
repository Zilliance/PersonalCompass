//
//  FeelBetterItemViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/6/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class FeelBetterItemViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    var didLayout = false

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // Fix text view not starting with text at top (!)
    // http://stackoverflow.com/questions/33979214/uitextview-text-starts-from-the-middle-and-not-the-top
    
    override func viewDidLayoutSubviews() {
        if self.didLayout == false {
            self.textView.setContentOffset(CGPoint.zero, animated: false)
            self.didLayout = true
        }
    }

}
