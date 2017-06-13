//
//  NeedViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/24/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class NeedViewController: AutoscrollableViewController {

    var currentCompass: Compass!
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
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
        
        if let need = self.currentCompass.need {
            self.textView.text = need
        }
    }
    
}

// MARK: - CompassFacetEditor

extension NeedViewController: CompassFacetEditor {
    func save() {
        self.currentCompass.need = self.textView.text
        self.currentCompass.lastEditedFacet = .need
    }
}

// MARK: - CompassValidation

extension NeedViewController: CompassValidation {
    var error: CompassError? {
        if self.textView.text.isEmpty {
            return .text
        } else {
            return nil
        }
    }
}

//MARK: - UITextViewDelegate

extension NeedViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
