//
//  TextViewPlaceholder.swift
//  Personal-Compass
//
//  Created by Philip Dow on 6/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

protocol TextViewPlaceholder {
    // implement in adopting class
    func placeholder(for textView: UITextView) -> String
    func placeholderTextColor(for textView: UITextView) -> UIColor
    func normalTextColor(for textView: UITextView) -> UIColor
    
    // default behavior
    func setupPlaceholderTextView(_ textView: UITextView, placeholder: String, attributes: [String: Any])
    
    // default behavior: implement UITextViewDelegate and call these methods
    func placeholderTextViewDidBeginEditing(_ textView: UITextView)
    func placeholderTextViewDidEndEditing(_ textView: UITextView)
}

extension TextViewPlaceholder {
    func setupPlaceholderTextView(_ textView: UITextView, placeholder: String, attributes: [String: Any]) {
        textView.attributedText = NSAttributedString(string: placeholder, attributes: attributes)
        textView.typingAttributes = attributes
    }
    
    func placeholderTextViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholder(for: textView) {
            textView.textColor = self.normalTextColor(for: textView)
            textView.text = ""
        }
    }
    
    func placeholderTextViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = self.placeholderTextColor(for: textView)
            textView.text = self.placeholder(for: textView)
        }
    }
}
