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
        
        if let thought = self.currentCompass.thoughtAboutEmotion {
            self.textView.text = thought
        }
        
         self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let emotion = self.currentCompass.emotion, let compassEmotion = self.currentCompass.compassEmotion {
            self.emotionIconImageView.image = emotion.icon
            self.emotionLabel.text = compassEmotion
        }
    }

}

extension ThoughtViewController: CompassFacetEditor {
    func save() {
        self.currentCompass.thoughtAboutEmotion = self.textView.text
        self.currentCompass.lastEditedFacet = .thought
    }
}

extension ThoughtViewController: CompassValidation {
    var error: CompassError? {
        if textView.text.characters.count == 0 {
            return .text
        }
        else {
            return nil
        }
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
}

