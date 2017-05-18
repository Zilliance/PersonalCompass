//
//  ThoughtViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/18/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class ThoughtViewController: UIViewController {
    
    // dummy data
    var emotion: Emotion? = Database.shared.allEmotions().first

    @IBOutlet weak var emotionIconImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let emotion = self.emotion {
            self.emotionIconImageView.image = emotion.icon
            self.emotionLabel.text = emotion.shortTitle
            self.emotionLabel.textColor = .red
        }
    }

}
