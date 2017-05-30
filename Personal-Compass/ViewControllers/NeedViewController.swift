//
//  NeedViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/24/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class NeedViewController: UIViewController, CompassFacetEditor, CompassValidation {

    var currentCompass: Compass!
    var error: CompassError? {
        return self.textView.text.characters.count == 0 ? .text : nil
    }
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        
        if let need = self.currentCompass.need {
            self.textView.text = need
        }
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func save() {
        self.currentCompass.need = self.textView.text
        self.currentCompass.lastEditedFacet = .need
    }

}

extension NeedViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
