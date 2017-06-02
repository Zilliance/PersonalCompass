//
//  CompassStressViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 19-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

enum StressType {
    case body
    case behaviour
}

final class CompassStressViewController: UIViewController, CompassFacetEditor, CompassValidation {
    
    @IBOutlet fileprivate var titleLable: UILabel!
    
    private var tableViewController: ItemsSelectionViewController!
    
    var currentCompass: Compass!
    
    var StringItemType: StringItem.Type!
    
    var notificationToken: NotificationToken? = nil
    
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
        
        self.titleLable.textColor = UIColor.darkBlue
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    private func setupView() {
        self.titleLable.text = self.title
    }
    
    func save() {
        
        self.tableViewController.saveAction(self.tableViewController.selectedItems)
        
        if self.StringItemType == BodyStress.self {
            self.currentCompass.lastEditedFacet = .body
        }
        else {
            self.currentCompass.lastEditedFacet = .behaviour
        }

    }
    
    private func setupItemsSelection<T: StringItem>(vc: ItemsSelectionViewController, preloadedItems: [T], destination: List<T>) {
        
        vc.items = preloadedItems
        vc.selectedItems = destination.count == 0 ? [] : Array(destination)
        
        vc.saveAction = { selectedItems in
            
            let items = selectedItems.flatMap {
                return $0 as? T
            }
            
            Database.shared.save {
                destination.removeAll()
                destination.append(objectsIn: items)
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let itemsSelectionsController = segue.destination as? ItemsSelectionViewController {
            
            itemsSelectionsController.type = self.StringItemType
            self.tableViewController = itemsSelectionsController
            
            if (self.StringItemType == BodyStress.self) {
                
                self.setupItemsSelection(vc: itemsSelectionsController, preloadedItems: Array(Database.shared.bodyStressStored), destination: self.currentCompass.bodyStressElements)

                notificationToken = Database.shared.bodyStressStored.addNotificationBlock({ _ in
                    
                    itemsSelectionsController.updateItems(newItems: Array(Database.shared.bodyStressStored))
                    
                })
                
            }
            else {
                
                self.setupItemsSelection(vc: itemsSelectionsController, preloadedItems: Array(Database.shared.behaviourStressStored), destination: self.currentCompass.behaviourStressElements)
                
                notificationToken = Database.shared.behaviourStressStored.addNotificationBlock({ _ in
                    
                    itemsSelectionsController.updateItems(newItems: Array(Database.shared.behaviourStressStored))
                    
                })
                
            }
            
            
        }
        
    }
    
}
