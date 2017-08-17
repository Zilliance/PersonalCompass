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
    
    private let picker = AKPickerView()
    
    fileprivate var currentIndex = 0 // indexOfNeutralEmotion
    
    var currentCompass: Compass!
    
    private(set) var tableViewController: ItemsSelectionViewController!

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
        
        self.picker.reloadData()
        self.picker.layoutSubviews()
    }
    
    private func loadData() {
        
        if let emotion = self.currentCompass.emotion {
            let index = self.emotions.index(of: emotion)
            self.currentIndex = index!
        }
        else {
             self.currentIndex = indexOfNeutralEmotion
        }
        
        DispatchQueue.main.async {
            self.picker.scrollToItem(self.currentIndex)
        }

        self.setupEmotionLabel()
        
        self.tableViewController.updateItems(newItems: Array(Database.shared.emotionItemsStored))

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let itemsSelectionsController = segue.destination as? ItemsSelectionViewController {
            
            itemsSelectionsController.type = EmotionItem.self
            self.tableViewController = itemsSelectionsController
            
            itemsSelectionsController.items = Array(Database.shared.emotionItemsStored)
            itemsSelectionsController.selectedItems = Array(self.currentCompass.emotionItems)
            
            itemsSelectionsController.saveAction = { selectedItems in
                
                let items = selectedItems.flatMap {
                    return $0 as? EmotionItem
                }
                
                Database.shared.save {
                    self.currentCompass.emotionItems.removeAll()
                    self.currentCompass.emotionItems.append(objectsIn: items)
                }
            }
            
            itemsSelectionsController.deleteAction = {[unowned self] toDeleteItem in
                
                guard let item = toDeleteItem as? EmotionItem else {
                    return assertionFailure()
                }
                
                Database.shared.save {
                    if let index = self.currentCompass.emotionItems.index(of: item) {
                        self.currentCompass.emotionItems.remove(objectAtIndex: index)
                    }
                }
                
                Database.shared.delete(item)
                
            }
        }
    }
}

// MARK: - CompassValidation

extension EmotionViewController: CompassValidation {
    var error: CompassError? {
        if let items = self.tableViewController?.selectedItems, items.count > 0 {
            return nil
        } else {
            return .selection
        }
    }
}

// MARK: - CompassFacetEditor

extension EmotionViewController: CompassFacetEditor {
    func save() {
        let emotion = self.emotions[self.currentIndex]
        
        self.currentCompass.emotion = emotion
        self.currentCompass.lastEditedFacet = .emotion
        self.tableViewController.saveAction(self.tableViewController.selectedItems)

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
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return String(item)
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

