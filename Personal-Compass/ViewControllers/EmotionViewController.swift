//
//  EmotionViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/17/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class EmotionCell: UITableViewCell {
    
    var currentCompass: Compass!
    
    static let cellHeight: CGFloat = 56.0
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(for emotion: Emotion) {
        self.titleLabel.text = emotion.shortTitle
        self.numberLabel.text = "\(emotion.level + 1)"
        self.iconImageView.image = emotion.icon
    }
    
}

class EmotionViewController: AutoscrollableViewController, CompassFacetEditor, CompassValidation {
    

    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var emotionTextField: UITextField!
    
    private let picker = AKPickerView()
    
    fileprivate var currentIndex = 0
    
    var currentCompass: Compass!
    
    var error: CompassError? {
        if self.emotionTextField.text?.characters.count == 0 {
            return .text
        }
        else {
            return nil
        }
    }

    
    fileprivate let emotions: [Emotion] = Array(Database.shared.allEmotions())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPicker()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadData()
    }
    
    private func setupPicker() {
        
        self.picker.translatesAutoresizingMaskIntoConstraints = false
        self.pickerContainerView.addSubview(self.picker)
        
        self.picker.interitemSpacing = 13
        
        self.picker.topAnchor.constraint(equalTo: self.pickerContainerView.topAnchor).isActive = true
        self.picker.leadingAnchor.constraint(equalTo: self.pickerContainerView.leadingAnchor).isActive = true
        self.picker.trailingAnchor.constraint(equalTo: self.pickerContainerView.trailingAnchor).isActive = true
        self.picker.bottomAnchor.constraint(equalTo: self.pickerContainerView.bottomAnchor).isActive = true
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
    }
    
    private func loadData() {
        
        if let emotion = self.currentCompass.emotion {
            let index = self.emotions.index(of: emotion)
            self.currentIndex = index!
            self.picker.scrollToItem(self.currentIndex, animated: true)
            self.emotionTextField.text = self.currentCompass.compassEmotion
        }
        
        self.setupEmotionLabel()
        
    }
    
    func save() {
        
        let emotion = self.emotions[self.currentIndex]
        self.currentCompass.emotion = emotion
        self.currentCompass.lastEditedFacet = .emotion
        self.currentCompass.compassEmotion = self.emotionTextField.text
        
    }
    
    fileprivate func setupEmotionLabel() {
        self.emotionLabel.text = self.emotions[self.currentIndex].longTitle
        self.emotionLabel.textColor = self.emotions[self.currentIndex].color
    }
    
    @IBAction func rightArrowAction(_ sender: UIButton) {
        
        guard self.currentIndex < self.emotions.count - 1 else {
           return
        }
        
        self.currentIndex += 1
        self.picker.scrollToItem(self.currentIndex, animated: true)
        self.setupEmotionLabel()

    }
    
    @IBAction func leftArrowAction(_ sender: UIButton) {
        
        guard self.currentIndex > 0 else {
            return
        }
        self.currentIndex -= 1
        self.picker.scrollToItem(self.currentIndex, animated: true)
        self.setupEmotionLabel()
    }
    
}

extension EmotionViewController: AKPickerViewDataSource, AKPickerViewDelegate {
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return emotions.count
    }
    
    func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        return self.emotions[item].icon!
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        self.currentIndex = item
        self.setupEmotionLabel()
    }
}

extension EmotionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

