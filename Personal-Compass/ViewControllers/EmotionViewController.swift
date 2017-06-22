//
//  EmotionViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/17/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import AKPickerView_Swift
import KMPlaceholderTextView
import MZFormSheetPresentationController

private let indexOfNeutralEmotion = 5

class EmotionViewController: AutoscrollableViewController {
    
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    private let picker = AKPickerView()
    
    fileprivate var currentIndex = 0 // indexOfNeutralEmotion
    
    var currentCompass: Compass!

    fileprivate let emotions: [Emotion] = Array(Database.shared.allEmotions())

    fileprivate var emotionHint: OnboardingPopover?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPicker()
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showEmotionHint()
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
        
        self.picker.reloadData()
        self.picker.layoutSubviews()
    }
    
    private func loadData() {
        
        if let emotion = self.currentCompass.emotion {
            let index = self.emotions.index(of: emotion)
            self.currentIndex = index!
            self.textView.text = self.currentCompass.compassEmotion
        }
        else {
             self.currentIndex = indexOfNeutralEmotion
        }
        
        DispatchQueue.main.async {
            self.picker.scrollToItem(self.currentIndex)
        }

        self.setupEmotionLabel()
    }
    
    fileprivate func setupEmotionLabel() {
        self.emotionLabel.text = self.emotions[self.currentIndex].title
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

// MARK: - Hints

extension EmotionViewController {
    // MARK: - Hint
    
    fileprivate func showEmotionHint() {
        if !UserDefaults.standard.bool(forKey: "EmotionHintShown") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let ss = self, ss.view.window != nil else {
                    return
                }
                
                UserDefaults.standard.set(true, forKey: "EmotionHintShown")
                ss.learnMore(ss)
            }
        }
    }
    
    fileprivate func learnMore(_ sender: Any) {
        guard let exampleViewController = UIStoryboard(name: "ExamplePopUp", bundle: nil).instantiateInitialViewController() as? ExamplePopUpViewController else {
            assertionFailure()
            return
        }
        
        UserDefaults.standard.set(true, forKey: "EmotionHintShown")
        
        exampleViewController.title = "Emotion"
        exampleViewController.text = "Now let’s identify how the stress of this situation is affecting you emotionally."
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: UIDevice.isSmallerThaniPhone6 ? 260 : 300, height: 200)
        formSheet.contentViewControllerTransitionStyle = .bounce
        self.present(formSheet, animated: true, completion: nil)
    }
}

// MARK: - CompassValidation

extension EmotionViewController: CompassValidation {
    var error: CompassError? {
        if self.textView.text.isEmpty {
            return .text
        } else {
            return nil
        }
    }
}

// MARK: - CompassFacetEditor

extension EmotionViewController: CompassFacetEditor {
    func save() {
        let emotion = self.emotions[self.currentIndex]
        
        self.currentCompass.emotion = emotion
        self.currentCompass.lastEditedFacet = .emotion
        self.currentCompass.compassEmotion = self.textView.text
    }
}

// MARK: - AKPicker

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

// MARK: - Text View Delegate

extension EmotionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}

// MARK: - Text Field Delegate

extension EmotionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

