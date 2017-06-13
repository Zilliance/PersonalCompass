//
//  InnerWisdom4ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/30/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import AKPickerView_Swift

// Feel Better Emotion

class InnerWisdom4ViewController: AutoscrollableViewController, CompassValidation, CompassFacetEditor {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var needMetTextField: UITextField!
    
    var currentCompass: Compass!
    
    var error: CompassError? {
        if self.needMetTextField.text?.characters.count == 0 {
            return .text
        }
        else {
            return nil
        }
    }
    
    private let picker = AKPickerView()
    
    fileprivate var currentIndex = 0
    
    fileprivate let emotions: [Emotion] = Array(Database.shared.allEmotions()).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    func save() {
        let emotion = self.emotions[self.currentIndex]
        self.currentCompass.needMetEmotion = emotion
        self.currentCompass.compassNeedMet = self.needMetTextField.text
        self.currentCompass.lastEditedFacet = .innerWisdom4
        
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
        
        if let emotion = self.currentCompass.needMetEmotion {
            let index = self.emotions.index(of: emotion)
            self.currentIndex = index!
            self.picker.scrollToItem(self.currentIndex, animated: true)
            self.needMetTextField.text = self.currentCompass.compassNeedMet
        }
        
        self.textView.text = self.currentCompass.editedNeed
        
        self.setupEmotionLabel()
        
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

extension InnerWisdom4ViewController: AKPickerViewDataSource, AKPickerViewDelegate {
    
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

extension InnerWisdom4ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
