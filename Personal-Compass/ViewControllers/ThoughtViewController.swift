//
//  ThoughtViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/18/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import RealmSwift
import KMPlaceholderTextView
import MZFormSheetPresentationController

class ThoughtViewController: AutoscrollableViewController {
    
    var currentCompass: Compass!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emotionIconImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    private func setupView() {
        self.setupDescriptionLabel()
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let thought = self.currentCompass.thoughtAboutEmotion {
            self.textView.text = thought
        }
        
        if let emotion = self.currentCompass.emotion {
            
            self.emotionIconImageView.image = emotion.icon
            self.emotionLabel.text = (currentCompass.emotionItems.flatMap { $0.title }).joined(separator: ", ")
            self.emotionLabel.textColor = currentCompass.emotion?.color
            self.numberLabel.textColor = currentCompass.emotion?.color
        }
    }
    
    private func setupDescriptionLabel() {
        let express = "Finish the sentence to see your thoughts about this stressor.  "
        let learn = "Learn more."
        
        let expressAttr = NSAttributedString(string: express, attributes: [
            NSFontAttributeName: UIFont.muliItalic(size: 13),
            NSForegroundColorAttributeName: UIColor.darkBlueText
        ])
        
        let learnAttr = NSAttributedString(string: learn, attributes: [
            NSFontAttributeName: UIFont.muliItalic(size: 13),
            NSForegroundColorAttributeName: UIColor.lightBlue
        ])
        
        let attrString = NSMutableAttributedString()
        attrString.append(expressAttr)
        attrString.append(learnAttr)
        
        self.descriptionLabel.attributedText = attrString
    }

    @IBAction func learnMore(_ sender: Any) {
        guard let exampleViewController = UIStoryboard(name: "ExamplePopUp", bundle: nil).instantiateInitialViewController() as? ExamplePopUpViewController else {
            assertionFailure()
            return
        }
        
        exampleViewController.title = "Your Thoughts"
        exampleViewController.text = "Behind every emotion is a thought or a bunch of thoughts. In fact, your stressor is not what is upsetting you; it’s your thoughts about your stressor that are upsetting you.\n\nWhen you get your thoughts out of your head and in front of you where you can see them, you can decide what to do about them. So get a few of them out right now."
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: UIDevice.isSmallerThaniPhone6 ? 260 : 300, height: 400)
        formSheet.contentViewControllerTransitionStyle = .bounce
        self.present(formSheet, animated: true, completion: nil)
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
        if self.textView.text.isEmpty {
            return .text
        } else {
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

