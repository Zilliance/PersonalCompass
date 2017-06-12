//
//  ThoughtViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/18/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import RealmSwift

class ThoughtViewController: AutoscrollableViewController {
    
    var currentCompass: Compass!
    
    @IBOutlet weak var emotionIconImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
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
        
        if let thought = self.currentCompass.thoughtAboutEmotion {
            self.textView.textColor = self.normalTextColor(for: textView)
            self.textView.text = thought
        }
        
        if let emotion = self.currentCompass.emotion, let compassEmotion = self.currentCompass.compassEmotion {
            self.emotionIconImageView.image = emotion.icon
            self.emotionLabel.text = compassEmotion
        }
    }

}

// MARK: - CompassFacetEditor

extension ThoughtViewController: CompassFacetEditor {
    func save() {
        self.currentCompass.thoughtAboutEmotion = self.textView.text
        self.currentCompass.lastEditedFacet = .thought
    }
}

// MARK: - CompassValidation

extension ThoughtViewController: CompassValidation {
    var error: CompassError? {
        if self.textView.text.isEmpty || self.textView.text == self.placeholder(for: self.textView) {
            return .text
        } else {
            return nil
        }
    }
}

// MARK: - TextViewPlaceholder

extension ThoughtViewController: TextViewPlaceholder {
    func placeholder(for textView: UITextView) -> String {
        return "For example, I am feeling fearful because I need to find a new job. Money is tight and time is running out. I have sent out a ton of resumes. I don’t know what else to do."
    }
    func placeholderTextColor(for textView: UITextView) -> UIColor {
        return .textPlaceholderColor
    }
    func normalTextColor(for textView: UITextView) -> UIColor {
        return .textInputColor
    }
}

// MARK: - UITextViewDelegate

extension ThoughtViewController: UITextViewDelegate {
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

