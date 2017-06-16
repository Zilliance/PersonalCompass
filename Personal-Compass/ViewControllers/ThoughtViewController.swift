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
    
    @IBOutlet weak var emotionIconImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    private func setupView() {
        self.setupDecriptionLabel()
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let thought = self.currentCompass.thoughtAboutEmotion {
            self.textView.text = thought
        }
        
        if let emotion = self.currentCompass.emotion, let compassEmotion = self.currentCompass.compassEmotion {
            self.emotionIconImageView.image = emotion.icon
            self.emotionLabel.text = compassEmotion
        }
    }
    
    private func setupDecriptionLabel() {
        let express = "Express all of your thoughts about your stressor that are causing you to feel the way you do.  "
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
        
        exampleViewController.title = "Your Ticker Tape"
        exampleViewController.text = "Every emotion is caused by a thought or a stream of thoughts. We call these thoughts your “Ticker Tape.”\n\nWrite your Ticker Tape here, expressing all of your thoughts about your stressor that are causing you to feel the way you do."
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: 300, height: 300)
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

