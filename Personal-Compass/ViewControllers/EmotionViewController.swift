//
//  EmotionViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/17/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

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

class EmotionViewController: CompassFacetEditorController, CompassValidation {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentCompass: Compass!
    
    var error: CompassError? {
        if let _ = self.tableView.indexPathsForSelectedRows {
            return nil
        }
        else {
            return .selection
        }
    }
    
    let emotions: [Emotion] = Array(Database.shared.allEmotions())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func save() {
        
        if let index = self.tableView.indexPathsForSelectedRows?.first {
            let emotion = self.emotions[index.row]
            self.currentCompass.emotion = emotion
            self.currentCompass.lastEditedFacet = .emotion
        }
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        guard let emotion = self.currentCompass.emotion else { return }
        if let row = self.emotions.index(of: emotion) {
            self.tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .middle)
        }

        
        
    }
}

extension EmotionViewController: UITableViewDataSource, UITableViewDelegate {
    
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
