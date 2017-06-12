//
//  InnerWisdom3ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/30/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class InnerWisdom3ViewController: AutoscrollableViewController, CompassValidation, CompassFacetEditor {
    
    @IBOutlet weak var needTextView: UITextView!
    @IBOutlet weak var concreteTextView: UITextView!
    
    var currentCompass: Compass!
    
    var error: CompassError? {
        if concreteTextView.text.characters.count == 0 {
            return .text
        }
        else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func save() {
        self.currentCompass.concreteStep = self.concreteTextView.text
        self.currentCompass.lastEditedFacet = .innerWisdom3
    }
    
    private func setupView() {
        
        self.concreteTextView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.concreteTextView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.concreteTextView.layer.borderWidth = App.Appearance.borderWidth
        self.concreteTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let concreteStep = self.currentCompass.concreteStep {
            self.concreteTextView.text = concreteStep
        }
        
        if let need = self.currentCompass.editedNeed {
            self.needTextView.text = need
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
}

extension InnerWisdom3ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
