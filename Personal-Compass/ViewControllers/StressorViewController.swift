//
//  StressorViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/17/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class StressorViewController: AutoscrollableViewController {
    
    fileprivate let maxTextlenght = 25

    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var counterLabel: UILabel!
    
    var currentCompass: Compass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.counterLabel.isHidden = true
    }
    
    private func setupView() {
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor

        if let stressor = self.currentCompass.stressor {
            self.textView.text = stressor
        }
    }
}

// MARK: - CompassValidation

extension StressorViewController: CompassValidation {
    var error: CompassError? {
        if self.textView.text.isEmpty {
            return .text
        } else {
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

// MARK: - UITextViewDelegate

extension StressorViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        // check max character lenght
        
        self.counterLabel.isHidden = false
        self.counterLabel.text = "\(maxTextlenght - textView.text.characters.count)"
        
        return textView.text.characters.count + (text.characters.count - range.length) <= maxTextlenght
      
    }
}
