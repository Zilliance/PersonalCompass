//
//  InnerWisdom3ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/30/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

// Concrete Step

class InnerWisdom3ViewController: AutoscrollableViewController {
    
    @IBOutlet weak var needTextView: UITextView!
    @IBOutlet weak var concreteTextView: KMPlaceholderTextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    var currentCompass: Compass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        self.needTextView.isScrollEnabled = false
        let fullSize = self.needTextView.sizeThatFits(self.needTextView.frame.size)
        self.textViewHeightConstraint.constant = min(fullSize.height, 80)
        self.needTextView.isScrollEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    private func setupView() {
        
        self.needTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
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
}

// MARK: - CompassValidation

extension InnerWisdom3ViewController: CompassValidation {
    var error: CompassError? {
        if concreteTextView.text.isEmpty {
            return .text
        }
        else {
            return nil
        }
    }
}

extension InnerWisdom3ViewController: CompassFacetEditor {
    func save() {
        self.currentCompass.concreteStep = self.concreteTextView.text
        self.currentCompass.lastEditedFacet = .innerWisdom3
    }

}

// MARK: - UITextViewDelegate

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
