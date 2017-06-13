//
//  InnerWisdom5ViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 01-06-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import RealmSwift

// How Else Can I Feel

final class InnerWisdom5ViewController: UIViewController {
    
    @IBOutlet fileprivate var titleLable: UILabel!
    
    private(set) var tableViewController: ItemsSelectionViewController!
    
    var currentCompass: Compass!
    
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emotionIcon: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    private func setupView() {
        emotionIcon.image = currentCompass.needMetEmotion?.icon
        emotionLabel.text = currentCompass.compassNeedMet
        emotionLabel.textColor = currentCompass.needMetEmotion?.color
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

// MARK: - CompassValidation

extension InnerWisdom5ViewController: CompassValidation {
    var error: CompassError? {
        if let items = self.tableViewController?.selectedItems, items.count > 0 {
            return nil
        } else {
            return .selection
        }
    }
}

// MARK: - CompassFacetEditor

extension InnerWisdom5ViewController: CompassFacetEditor {
    func save() {
        self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentCompass.lastEditedFacet = .innerWisdom5
    }
}
