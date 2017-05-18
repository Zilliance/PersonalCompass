//
//  EmotionViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/17/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class EmotionCell: UITableViewCell {
    
    static let cellHeight: CGFloat = 56.0
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(for emotion: Emotion) {
        self.titleLabel.text = emotion.shortTitle
        self.numberLabel.text = "\(emotion.level)"
        self.iconImageView.image = emotion.icon
    }
    
}

class EmotionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let emotions: [Emotion] = Array(Database.shared.allEmotions())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
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
