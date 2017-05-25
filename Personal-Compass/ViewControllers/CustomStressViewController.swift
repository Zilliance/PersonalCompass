//
//  CustomStressViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/25/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class CustomStressViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var type: StressType = .body
    
    fileprivate let placeholderText = "In one or two words, describe how the situation is makes you feel physically"
    fileprivate let placeholderTextColor = UIColor.lightGray
    fileprivate let normalTextColor = UIColor.darkGray

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
    }
    
    private func setupView() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.save))
        
        self.title = self.type == .body ? "Custom Body Stress" : "Custom Behavior Stress"
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor

        self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let attrs = [
            NSFontAttributeName: UIFont.muliRegular(size: 17),
            NSForegroundColorAttributeName: self.placeholderTextColor
        ]
        
        self.textView.typingAttributes = attrs
        self.textView.attributedText = NSAttributedString(string: placeholderText, attributes: attrs)
        
    }
    
    fileprivate func showPlaceholder() {
        self.textView.textColor = placeholderTextColor
        self.textView.text = placeholderText
    }
    
    fileprivate func hidePlaceholder() {
        self.textView.textColor = normalTextColor
        self.textView.text = ""
    }

    
}

extension CustomStressViewController {
    
    @objc func closeView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        
        guard self.textView.text.characters.count > 0 else {
            self.showAlert(title: "", message: "Please enter text")
            return
        }
        self.dismiss(animated: true, completion: nil)
    }

}

extension CustomStressViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            self.hidePlaceholder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            self.showPlaceholder()
        }
    }
}
