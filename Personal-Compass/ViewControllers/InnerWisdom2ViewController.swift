//
//  InnerWisdom2ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/26/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class InnerWisdom2ViewController: UIViewController, CompassValidation, CompassFacetEditor {
    
    @IBOutlet weak var textView: UITextView!
    
    var error: CompassError? {
        if textView.text.characters.count == 0 {
            return .text
        }
        else {
            return nil
        }
    }
    
    var currentCompass: Compass!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func save() {
        self.currentCompass.editedNeed = self.textView.text
        self.currentCompass.lastEditedFacet = .innerWisdom2
    }
    
    private func setupView() {
        
        self.textView.text = self.currentCompass.editedNeed != nil ? self.currentCompass.editedNeed : self.currentCompass.need
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
}

extension InnerWisdom2ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
