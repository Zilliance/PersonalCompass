//
//  InnerWisdom4ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/30/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class InnerWisdom4ViewController: UIViewController, CompassValidation, CompassFacetEditor {
    
    var currentCompass: Compass!
    
    var error: CompassError? {
        if let _ = self.tableView.indexPathsForSelectedRows {
            return nil
        }
        else {
            return .selection
        }
    }


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    fileprivate let emotions: [Emotion] = Array(Database.shared.allEmotions()).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    
    }
    
    func save() {
        if let index = self.tableView.indexPathsForSelectedRows?.first {
            let emotion = self.emotions[index.row]
            self.currentCompass.needMetEmotion = emotion
            self.currentCompass.lastEditedFacet = .innerWisdom4
        }
    }
    
    private func setupView() {
        if let need = self.currentCompass.editedNeed {
            self.textView.text = need
        }
        
        self.tableView.tableFooterView = UIView()
        
        guard let emotion = self.currentCompass.needMetEmotion else { return }
        if let row = self.emotions.index(of: emotion) {
            self.tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .middle)
        }
    }


}

extension InnerWisdom4ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emotions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmotionCell", for: indexPath) as! EmotionCell
        cell.setup(for: emotions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EmotionCell.cellHeight
    }
}

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
