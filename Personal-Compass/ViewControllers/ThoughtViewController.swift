//
//  ThoughtViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/18/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class ThoughtViewController: UIViewController, CompassValidation {
    
    var currentCompass: Compass!
    
    var error: CompassError? {
        if textView.text.characters.count == 0 {
            return .text
        }
        else {
            return nil
        }
    }

    @IBOutlet weak var emotionIconImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Database.shared.save {
            self.currentCompass.thoughtAboutEmotion = self.textView.text
            self.currentCompass.lastEditedFacet = .thought
        }
    }
    
    private func setupView() {
        
        if let thought = self.currentCompass.thoughtAboutEmotion {
            self.textView.text = thought
        }
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let emotion = self.currentCompass.emotion {
            self.emotionIconImageView.image = emotion.icon
            self.emotionLabel.text = emotion.shortTitle
            self.emotionLabel.textColor = .red
        }
    }

}
