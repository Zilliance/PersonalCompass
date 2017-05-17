//
//  StressorViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/17/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class StressorViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
    }

}

extension StressorViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
}
