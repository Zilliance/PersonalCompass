//
//  InnerWisdom2ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/26/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

// Update Need

class InnerWisdom2ViewController: AutoscrollableViewController {
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    var currentCompass: Compass!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupView() {
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.text = self.currentCompass.editedNeed != nil ? self.currentCompass.editedNeed : self.currentCompass.need
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
}

// MARK: - CompassValidation

extension InnerWisdom2ViewController: CompassValidation {
    var error: CompassError? {
        if textView.text.isEmpty {
            return .text
        } else {
            return nil
        }
    }
}

// MARK: - CompassFacetEditor

extension InnerWisdom2ViewController: CompassFacetEditor {
    func save() {
        self.currentCompass.editedNeed = self.textView.text
        self.currentCompass.lastEditedFacet = .innerWisdom2
    }
}

// MARK: - UITextViewDelegate

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
