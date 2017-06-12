//
//  NeedViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/24/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class NeedViewController: AutoscrollableViewController {

    var currentCompass: Compass!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }

    private func setupView() {
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.setupPlaceholderTextView(self.textView, placeholder: self.placeholder(for: self.textView), attributes: [
            NSFontAttributeName: UIFont.muliLight(size: 14),
            NSForegroundColorAttributeName: self.placeholderTextColor(for: self.textView)
        ])
        
        if let need = self.currentCompass.need {
            self.textView.textColor = self.normalTextColor(for: textView)
            self.textView.text = need
        }
    }
    
}

// MARK: - CompassFacetEditor

extension NeedViewController: CompassFacetEditor {
    func save() {
        if self.textView.text != self.placeholder(for: self.textView) {
            self.currentCompass.need = self.textView.text
        }
        self.currentCompass.lastEditedFacet = .need
    }
}

// MARK: - CompassValidation

extension NeedViewController: CompassValidation {
    var error: CompassError? {
        if self.textView.text.isEmpty || self.textView.text == self.placeholder(for: self.textView) {
            return .text
        } else {
            return nil
        }
    }
}

// MARK: - TextViewPlaceholder

extension NeedViewController: TextViewPlaceholder {
    func placeholder(for textView: UITextView) -> String {
        return "For example, I need a job, I need my friend to understand how I feel, or I need some quiet downtime to recharge."
    }
    func placeholderTextColor(for textView: UITextView) -> UIColor {
        return .textPlaceholderColor
    }
    func normalTextColor(for textView: UITextView) -> UIColor {
        return .textInputColor
    }
}

//MARK: - UITextViewDelegate

extension NeedViewController: UITextViewDelegate {
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
