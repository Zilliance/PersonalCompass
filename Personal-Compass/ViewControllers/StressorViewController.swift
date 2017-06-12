//
//  StressorViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/17/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class StressorViewController: AutoscrollableViewController {

    @IBOutlet weak var textView: UITextView!
    
    var currentCompass: Compass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        
        if let stressor = self.currentCompass.stressor {
            self.textView.text = stressor
        }
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.setupPlaceholderTextView(self.textView, placeholder: self.placeholder(for: self.textView), attributes: [
            NSFontAttributeName: UIFont.muliRegular(size: 14),
            NSForegroundColorAttributeName: self.placeholderTextColor(for: self.textView)
        ])
    }
    
}

// MARK: - CompassValidation

extension StressorViewController: CompassValidation {
    var error: CompassError? {
        if self.textView.text.characters.count == 0 || self.textView.text == self.placeholder(for: self.textView) {
            return .text
        }
        else {
            return nil
        }
    }
}

// MARK: - CompassFacetEditor

extension StressorViewController: CompassFacetEditor {
    func save() {
        self.currentCompass.stressor = self.textView.text
        self.currentCompass.lastEditedFacet = .stressor
    }
}

// MARK: - TextViewPlaceholder

extension StressorViewController: TextViewPlaceholder {
    func placeholder(for textView: UITextView) -> String {
        return "Enter one or two words that describe your stressor, for example: Money, Relationship with Mom, or Work"
    }
    func placeholderTextColor(for textView: UITextView) -> UIColor {
        return .textPlaceholderColor
    }
    func normalTextColor(for textView: UITextView) -> UIColor {
        return .textInputColor
    }
}

// MARK: - UITextViewDelegate

extension StressorViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholderTextViewDidBeginEditing(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.placeholderTextViewDidEndEditing(textView)
    }
}
