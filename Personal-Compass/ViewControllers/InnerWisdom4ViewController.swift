//
//  InnerWisdom4ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/30/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import AKPickerView_Swift
import KMPlaceholderTextView
// Feel Better Emotion

class InnerWisdom4ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emotionTextView: KMPlaceholderTextView!

    var currentCompass: Compass!
    
    private let picker = AKPickerView()
    
    fileprivate var currentIndex = 0
    
    fileprivate let emotions: [Emotion] = Array(Database.shared.allEmotions())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.setupPicker()
        self.setupTextView()
    }
    
    fileprivate var scrolledToPositiveEmotionTextView = false
    
    override func viewDidLayoutSubviews() {
        self.resetTextViewConstraint()
        
        if (self.scrolledToPositiveEmotionTextView) {
            self.view.frame.origin.y = self.view.frame.origin.y - 90
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    private func resetTextViewConstraint() {
        self.textView.isScrollEnabled = false
        let fullSize = self.textView.sizeThatFits(self.textView.frame.size)
        self.textViewHeightConstraint.constant = min(fullSize.height, 80)
        self.textView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.loadData()
    }
    
    var editingViewFrame: CGRect? {
        return self.view.subviews.filter {
            $0.isFirstResponder == true
            }.first?.frame
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let editingView = self.containerView.subviews.filter {
            $0.isFirstResponder == true
            }.first
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, let editingView = editingView {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
            
            let childStartPoint = self.view.convert(editingView.frame.origin, to: scrollView)
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y - 20, width: 1, height: editingView.frame.height), animated: true)
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = .zero
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
    
    private func setupTextView() {
        self.emotionTextView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        self.emotionTextView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.emotionTextView.layer.borderWidth = App.Appearance.borderWidth
        self.emotionTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func loadData() {
        
        if let emotion = self.currentCompass.needMetEmotion {
            let index = self.emotions.index(of: emotion)
            self.currentIndex = index!
            self.picker.scrollToItem(self.currentIndex, animated: true)
            
            self.emotionTextView.text = self.currentCompass.compassNeedMet
        }
        
        self.textView.text = self.currentCompass.editedNeed
        
        self.setupEmotionLabel()
        
        self.resetTextViewConstraint()
        
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
        self.currentCompass.compassNeedMet = self.emotionTextView.text
        self.currentCompass.lastEditedFacet = .innerWisdom4
    }
}

// MARK: - CompassValidation

extension InnerWisdom4ViewController: CompassValidation {
    var error: CompassError? {
        if self.emotionTextView.text?.isEmpty == true {
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
        
        if (self.scrollView.contentSize.height > self.scrollView.frame.size.height) {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height), animated: true)
        }
    }
    
}

// MARK: - UITextViewDelegate

extension InnerWisdom4ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
