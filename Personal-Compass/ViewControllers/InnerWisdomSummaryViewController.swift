//
//  InnerWisdomSummaryViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 02-06-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class InnerWisdomSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SummaryViewControllerProtocol {
    
    enum RowType: Int {
        case need
        case actionStep
        case emotion
        case secondActionStep
        
        static var count = {
            return 4
        }
        
        var sceneAssociated: CompassScene {
            switch self {
            case .need:
                return CompassScene.innerWisdom2
            case .actionStep:
                return CompassScene.innerWisdom3
            case .emotion:
                return CompassScene.innerWisdom4
            case .secondActionStep:
                return CompassScene.innerWisdom5
            }
        }

    }

    var currentCompass: Compass!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var tableTopSeparation: NSLayoutConstraint!
    
    var shouldShowFooterHeader: Bool = true
    
    @IBOutlet var headerLabel: UILabel!
    
    var sceneSelectionAction: ((CompassScene) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCells()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 84
        
        if (!shouldShowFooterHeader) {
            self.tableTopSeparation.constant = 0
            headerLabel.isHidden = true
        }
        
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 2))
        additionalSeparator.backgroundColor = UIColor.silverColor
        
        self.tableView.tableHeaderView = additionalSeparator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func loadCells() {
        var nib = UINib(nibName: "EmotionSummaryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EmotionSummaryCell")
        
        nib = UINib(nibName: "CompassFacetSummaryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CompassFacetSummaryCell")
        
    }
    

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
        case .need:
            cell = tableView.dequeueReusableCell(withIdentifier: "CompassFacetSummaryCell", for: indexPath) as! CompassFacetSummaryCell

            cell.title.text = "Need"
            cell.label.text = currentCompass.editedNeed
            cell.label.textColor = UIColor.innerWisdom

        case .actionStep:
            cell = tableView.dequeueReusableCell(withIdentifier: "CompassFacetSummaryCell", for: indexPath) as! CompassFacetSummaryCell
            cell.title.text = "Action Step"
            cell.label.text = currentCompass.concreteStep
            cell.label.textColor = UIColor.innerWisdom
            
        case .emotion:
            let emotionCell = tableView.dequeueReusableCell(withIdentifier: "EmotionSummaryCell", for: indexPath) as! EmotionSummaryCell

            let emotionElements = (currentCompass.needMetEmotionItems.flatMap { $0.title }).joined(separator: ",\n")
            emotionCell.title.text = "Emotion"
            emotionCell.label.text = emotionElements
            emotionCell.label.textColor = currentCompass.needMetEmotion?.color
            emotionCell.levelLabel.text = String(currentCompass.emotion?.level ?? 0)
            emotionCell.levelLabel.textColor = currentCompass.emotion?.color
            emotionCell.iconView.image = currentCompass.needMetEmotion?.icon

            cell = emotionCell
            
        case .secondActionStep:

            let positiveActivities = (currentCompass.positiveActivities.flatMap { $0.title }).joined(separator: ",\n")
            
            let attributes = [ NSFontAttributeName: UIFont.muliSemiBold(size: 14), NSForegroundColorAttributeName: UIColor.innerWisdom ]
            let attributedText = NSMutableAttributedString(string: "I can also feel this emotion by\n" + positiveActivities, attributes: attributes)
            let alsoTextRange = (attributedText.string as NSString).range(of: "I can also feel this emotion by")
            
            attributedText.addAttribute(NSFontAttributeName, value: UIFont.muliLightItalic(size: 14), range: alsoTextRange)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.battleshipGrey, range: alsoTextRange)
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CompassFacetSummaryCell", for: indexPath) as! CompassFacetSummaryCell
            
            cell.label.attributedText = attributedText
            cell.title.text = "Action Step"

        }
        
        cell.titleContainer.backgroundColor = UIColor.innerWisdom
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = RowType(rawValue: indexPath.row) else {
            return assertionFailure()
        }
        
        sceneSelectionAction?(row.sceneAssociated)
        
    }
    
}

