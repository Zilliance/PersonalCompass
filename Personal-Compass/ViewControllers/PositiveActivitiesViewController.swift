//
//  PositiveActivitiesViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 01-06-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import RealmSwift


final class PositiveActivitiesViewController: UIViewController, CompassFacetEditor, CompassValidation {
    
    @IBOutlet fileprivate var titleLable: UILabel!
    
    private var tableViewController: ItemsSelectionViewController!
    
    var currentCompass: Compass!
    
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emotionIcon: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    
    
    var error: CompassError? {
        if let items = self.tableViewController?.selectedItems, items.count > 0 {
            return nil
        }
        else {
            return .selection
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        emotionIcon.image = currentCompass.needMetEmotion?.icon
        emotionLabel.text = currentCompass.needMetEmotion?.longTitle
        emotionLabel.textColor = currentCompass.needMetEmotion?.color
        
    }
    
    func save() {
        
        self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentCompass.lastEditedFacet = .innerWisdom5
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let itemsSelectionsController = segue.destination as? ItemsSelectionViewController {
            
            itemsSelectionsController.type = PositiveActivity.self
            self.tableViewController = itemsSelectionsController
            
            itemsSelectionsController.items = Array(Database.shared.positiveActivitiesStored)
            itemsSelectionsController.selectedItems = Array(self.currentCompass.positiveActivities)
                        
            itemsSelectionsController.saveAction = { selectedItems in
                
                let items = selectedItems.flatMap {
                    return $0 as? PositiveActivity
                }
                
                Database.shared.save {
                    self.currentCompass.positiveActivities.removeAll()
                    self.currentCompass.positiveActivities.append(objectsIn: items)
                }
                
            }

            
        }
        
    }
    
}
