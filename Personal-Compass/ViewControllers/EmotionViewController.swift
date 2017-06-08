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

class EmotionViewController: UIViewController, CompassFacetEditor, CompassValidation {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emotionLabel: UILabel!
    var currentCompass: Compass!
    
    var error: CompassError? {
        if let _ = self.tableView.indexPathsForSelectedRows {
            return nil
        }
        else {
            return .selection
        }
    }
    
    fileprivate let emotions: [Emotion] = Array(Database.shared.allEmotions())

    override func viewDidLoad() {
        super.viewDidLoad()
        let picker = AKPickerView(frame: CGRect(x: 0, y: 0, width: 375, height: 500))
        self.view.addSubview(picker)
            
        picker.delegate = self
        picker.dataSource = self
    }
    
    func save() {
        
        if let index = self.tableView.indexPathsForSelectedRows?.first {
            let emotion = self.emotions[index.row]
            self.currentCompass.emotion = emotion
            self.currentCompass.lastEditedFacet = .emotion
        }
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
        self.emotionLabel.text = self.emotions[item].shortTitle
    }
}

