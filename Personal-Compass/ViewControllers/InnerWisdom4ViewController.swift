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

private let indexOfNeutralEmotion = 5

class InnerWisdom4ViewController: AutoscrollableViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var needMetTextField: UITextField!
    
    var currentCompass: Compass!
    
    private let picker = AKPickerView()
    
    fileprivate var currentIndex = 0
    
    fileprivate let emotions: [Emotion] = Array(Database.shared.allEmotions())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.setupPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        if let emotion = self.currentCompass.needMetEmotion {
            let index = self.emotions.index(of: emotion)
            self.currentIndex = index!
            self.picker.scrollToItem(self.currentIndex)
            self.needMetTextField.text = self.currentCompass.compassNeedMet
        }
        else {
            self.currentIndex = indexOfNeutralEmotion
        }
    
        DispatchQueue.main.async {
            self.picker.scrollToItem(self.currentIndex)
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

// MARK: - CompassFacetEditor

extension InnerWisdom4ViewController: CompassFacetEditor {
    func save() {
        let emotion = self.emotions[self.currentIndex]
        self.currentCompass.needMetEmotion = emotion
        self.currentCompass.compassNeedMet = self.needMetTextField.text
        self.currentCompass.lastEditedFacet = .innerWisdom4
    }
}

// MARK: - CompassValidation

extension InnerWisdom4ViewController: CompassValidation {
    var error: CompassError? {
        if self.needMetTextField.text?.isEmpty == true {
            return .text
        } else {
            return nil
        }
    }
}

// MARK: - AKPicker

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

// MARK: - UITextFieldDelegate

extension InnerWisdom4ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
