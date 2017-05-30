//
//  StressorViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/17/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class StressorViewController: CompassFacetEditorController, CompassValidation {

    @IBOutlet weak var textView: UITextView!
    
    var currentCompass: Compass!
    
    var error: CompassError? {
        if self.textView.text.characters.count == 0 {
            return .text
        }
        else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
        
    override func save() {
        self.currentCompass.stressor = self.textView.text
        self.currentCompass.lastEditedFacet = .stressor
    }
    
    private func setupView() {
        
        if let stressor = self.currentCompass.stressor {
            self.textView.text = stressor
        }
        
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
