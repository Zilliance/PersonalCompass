//
//  SummaryViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 24-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, SummaryViewControllerProtocol {
    
    enum RowType: Int {
        case feeling
        case thought
        case bodyStress
        case behaviourStress
        
        static var count = {
            return 4
        }
        
        var sceneAssociated: CompassScene {
            switch self {
            case .feeling:
                return CompassScene.emotion
            case .thought:
                return CompassScene.thought
            case .bodyStress:
                return CompassScene.body
            case .behaviourStress:
                return CompassScene.behavior
            }
        }
    }
    
    var sceneSelectionAction: ((CompassScene) -> ())?
    
    var currentCompass: Compass!
    var shouldShowFooterHeader: Bool = true
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 84
        
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 2))
        additionalSeparator.backgroundColor = UIColor.silverColor

        self.tableView.tableHeaderView = additionalSeparator
        
        if (!self.shouldShowFooterHeader) {
            
            self.headerLabel.isHidden = true
            self.footerLabel.isHidden = true
            
            self.tableViewTopConstraint.isActive = false
            self.tableViewBottomConstraint.isActive = false
            
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
        
        loadCells()

    }
    
    private func loadCells() {
        var nib = UINib(nibName: "EmotionSummaryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EmotionSummaryCell")
        
        nib = UINib(nibName: "CompassFacetSummaryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CompassFacetSummaryCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

}

extension SummaryViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowType.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: CompassFacetSummaryCell!
        
        guard let row = RowType(rawValue: indexPath.row) else {
            assertionFailure()
            return cell
        }
        
        switch row {
        case .feeling:
            let emotionCell = tableView.dequeueReusableCell(withIdentifier: "EmotionSummaryCell", for: indexPath) as! EmotionSummaryCell
            let emotionElements = (currentCompass.emotionItems.flatMap { $0.title }).joined(separator: ",\n")
            emotionCell.label.text = emotionElements
            emotionCell.label.textColor = currentCompass.emotion?.color
            emotionCell.iconView.image = currentCompass.emotion?.icon
            cell = emotionCell
            
        case .thought:
            cell = tableView.dequeueReusableCell(withIdentifier: "CompassFacetSummaryCell", for: indexPath) as! CompassFacetSummaryCell
            
            let attributes = [
                NSFontAttributeName: UIFont.muliSemiBold(size: 14),
                NSForegroundColorAttributeName: row.sceneAssociated.color
            ]
            let attributedText = NSMutableAttributedString(string: "Because " + (currentCompass.thoughtAboutEmotion ?? ""), attributes: attributes)
            let becauseOfRange = (attributedText.string as NSString).range(of: "Because")
            
            attributedText.addAttribute(NSFontAttributeName, value: UIFont.muliLightItalic(size: 14), range: becauseOfRange)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.battleshipGrey, range: becauseOfRange)
            
            cell.label.attributedText = attributedText
            
            
        case .bodyStress:
            cell = tableView.dequeueReusableCell(withIdentifier: "CompassFacetSummaryCell", for: indexPath) as! CompassFacetSummaryCell
            let stressElements = (currentCompass.bodyStressElements.flatMap { $0.title }).joined(separator: ",\n")
            cell.label.text = stressElements
            cell.label.textColor = row.sceneAssociated.color
        
        case .behaviourStress:
            cell = tableView.dequeueReusableCell(withIdentifier: "CompassFacetSummaryCell", for: indexPath) as! CompassFacetSummaryCell
            
            let stressElements = (currentCompass.behaviourStressElements.flatMap { $0.title }).joined(separator: ",\n")
            cell.label.text = stressElements
            cell.label.textColor = row.sceneAssociated.color

        }
        
        cell.titleContainer.backgroundColor = row.sceneAssociated.color
        cell.title.text = row.sceneAssociated.title
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = RowType(rawValue: indexPath.row) else {
            return assertionFailure()
        }
        
        sceneSelectionAction?(row.sceneAssociated)
    }

}
