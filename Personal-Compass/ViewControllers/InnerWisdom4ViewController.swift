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
import MZFormSheetPresentationController

// Feel Better Emotion

class InnerWisdom4ViewController: UIViewController {

    private let indexOfNeutralEmotion = 5


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emotionTextView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionLabel: UILabel!

    var currentCompass: Compass!
    
    private let picker = AKPickerView()
    
    fileprivate var currentIndex = 0
    
    fileprivate let emotions: [Emotion] = Array(Database.shared.allEmotions())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.setupPicker()
        self.setupTextView()
        self.setupDescriptionLabel()
    }
    
    override func viewDidLayoutSubviews() {
        self.resetTextViewConstraint()
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
        self.showLearnMoreFirstTime()
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
        else {
            self.currentIndex = indexOfNeutralEmotion
        }
    
        DispatchQueue.main.async {
            self.picker.scrollToItem(self.currentIndex)
        }

        
        self.textView.text = self.currentCompass.editedNeed
        
        self.setupEmotionLabel()
        
        self.resetTextViewConstraint()
        
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
    
    // MARK: - Learn More
    
    // TODO: MOVE TO INNER WISDOM 4
    
    private func setupDescriptionLabel() {
        let text = "Feel better, even if you can't eliminate your stressor.  "
        let learn = "Learn more."
        
        let textAttr = NSAttributedString(string: text, attributes: [
            NSFontAttributeName: UIFont.muliItalic(size: 13),
            NSForegroundColorAttributeName: UIColor.darkBlueText
            ])
        
        let learnAttr = NSAttributedString(string: learn, attributes: [
            NSFontAttributeName: UIFont.muliItalic(size: 13),
            NSForegroundColorAttributeName: UIColor.lightBlue
            ])
        
        let attrString = NSMutableAttributedString()
        attrString.append(textAttr)
        attrString.append(learnAttr)
        
        self.descriptionLabel.attributedText = attrString
    }
    
    fileprivate func showLearnMoreFirstTime() {
        if !UserDefaults.standard.bool(forKey: "FeelBetterHintShown") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let ss = self, ss.view.window != nil else {
                    return
                }
                
                UserDefaults.standard.set(true, forKey: "FeelBetterHintShown")
                ss.learnMore(ss)
            }
        }
    }
    
    @IBAction func learnMore(_ sender: Any) {
        guard let exampleViewController = UIStoryboard(name: "ExamplePopUp", bundle: nil).instantiateInitialViewController() as? ExamplePopUpViewController else {
            assertionFailure()
            return
        }
        
        UserDefaults.standard.set(true, forKey: "FeelBetterHintShown")
        
        exampleViewController.title = "Feel Better"
        exampleViewController.text = "The goal of the Personal Compass is to help you feel better, even if you can’t eliminate your stressor.\n\nMost of us make the mistake of thinking a SITUATION has to change in order for us to feel better, but feeling better is not about the situational outcome. Rather, it’s about an EMOTIONAL outcome.\n\nOn this screen, we want you to identify how you would feel if you got your need met, which is ultimately how you would like to feel regardless of what happens with your stressor."
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: UIDevice.isSmallerThaniPhone6 ? 260 : 300, height: 400)
        formSheet.contentViewControllerTransitionStyle = .bounce
        self.present(formSheet, animated: true, completion: nil)
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
