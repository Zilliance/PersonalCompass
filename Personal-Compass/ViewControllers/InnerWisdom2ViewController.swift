//
//  InnerWisdom2ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/26/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import MZFormSheetPresentationController

// Update Need

class InnerWisdom2ViewController: AutoscrollableViewController {
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var currentCompass: Compass!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDescriptionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    private func setupView() {
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.text = self.currentCompass.editedNeed != nil ? self.currentCompass.editedNeed : self.currentCompass.need
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    private func setupDescriptionLabel() {
        let text = "After checking in with your Inner Wisdom, do you want to keep your answer or change it? Remember, your Inner Wisdom wants you to find a  way to feel better that’s in your control.  "
        let learn = "Learn more."
        
        let textAttr = NSAttributedString(string: text, attributes: [
            NSFontAttributeName: UIFont.muliItalic(size: 13),
            NSForegroundColorAttributeName: UIColor.darkBlueText
            ])
        
        let learnAttr = NSAttributedString(string: learn, attributes: [
            NSFontAttributeName: UIFont.muliItalic(size: 13),
            NSForegroundColorAttributeName: UIColor.lightBlue
            ])
        
        let attrString = NSMutableAttributedString()
        attrString.append(textAttr)
        attrString.append(learnAttr)
        
        self.descriptionLabel.attributedText = attrString
    }

    // MARK: - Learn More
    
    @IBAction func learnMore(_ sender: Any) {
        guard let exampleViewController = UIStoryboard(name: "ExamplePopUp", bundle: nil).instantiateInitialViewController() as? ExamplePopUpViewController else {
            assertionFailure()
            return
        }
        
        exampleViewController.title = "Your Inner Wisdom"
        exampleViewController.text = "Your Inner Wisdom knows it is always in your control to feel better. For example: if what you need to feel better is a job, your Inner Wisdom knows it is possible to feel better even before you get the job.\n\nThe Inner Wisdom  answer, which is what’s in your control, might be \"I need to stop freaking out so that I can think clearly and make a plan.\""
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: UIDevice.isSmallerThaniPhone6 ? 260 : 300, height: 400)
        formSheet.contentViewControllerTransitionStyle = .bounce
        self.present(formSheet, animated: true, completion: nil)
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
