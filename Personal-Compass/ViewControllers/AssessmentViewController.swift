//
//  AssessmentViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 24-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

protocol AssessmentViewControllerDelegate {
    
    func didSelectScene(scene: CompassScene)
    
}

class AssessmentViewController: UIViewController {
    
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
    
    var currentCompass: Compass!
    var delegate: AssessmentViewControllerDelegate!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 84

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AssessmentViewController: UITableViewDataSource, UITableViewDelegate {
    
    
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
            emotionCell.label.text = (currentCompass.emotion?.longTitle ?? "")
            emotionCell.iconView.image = currentCompass.emotion?.icon
            emotionCell.label.textColor = row.sceneAssociated.color
            
            cell = emotionCell
        case .thought:
            cell = tableView.dequeueReusableCell(withIdentifier: "CompassFacetSummaryCell", for: indexPath) as! CompassFacetSummaryCell
            cell.label.text = "Because of " + (currentCompass.thoughtAboutEmotion ?? "")
        case .bodyStress:
            cell = tableView.dequeueReusableCell(withIdentifier: "CompassFacetSummaryCell", for: indexPath) as! CompassFacetSummaryCell
            let stressElements = (currentCompass.bodyStressElements.flatMap { $0.title }).joined(separator: "\n")
            cell.label.text = stressElements
            cell.label.textColor = row.sceneAssociated.color
        
        case .behaviourStress:
            cell = tableView.dequeueReusableCell(withIdentifier: "CompassFacetSummaryCell", for: indexPath) as! CompassFacetSummaryCell
            
            let stressElements = (currentCompass.behaviourStressElements.flatMap { $0.title }).joined(separator: "\n")
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

        delegate.didSelectScene(scene: row.sceneAssociated)
        
    }
    
}
