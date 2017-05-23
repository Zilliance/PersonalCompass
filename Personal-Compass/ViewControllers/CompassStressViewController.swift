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

final class CompassStressViewController: UIViewController, CompassValidation {
    
    @IBOutlet fileprivate var titleLable: UILabel!
    
    private var tableViewController: StressSelectionViewController?
    
    var currentCompass: Compass!
    
    var stressItemType: StressType = .body
    
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
        
        self.titleLable.text = self.title
        
        self.titleLable.textColor = UIColor.darkBlue
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Database.shared.save {
            if self.stressItemType == .body {
                self.currentCompass.lastEditedFacet = .body
            }
            else {
                self.currentCompass.lastEditedFacet = .behaviour
            }
        }
    }
    
    private func setupItemsSelection<T: StressItem>(vc: StressSelectionViewController, preloadedItems: [T], destination: List<T>) {
        
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
        
        if let itemsSelectionsController = segue.destination as? StressSelectionViewController {
            
            self.tableViewController = itemsSelectionsController
            
            if (self.stressItemType == .body) {
                
                self.setupItemsSelection(vc: itemsSelectionsController, preloadedItems: Array(Database.shared.bodyStressStored), destination: self.currentCompass.bodyStressElements)

            }
            else {
                
                self.setupItemsSelection(vc: itemsSelectionsController, preloadedItems: Array(Database.shared.behaviourStressStored), destination: self.currentCompass.behaviourStressElements)
                
            }
            
            
        }
        
    }
    
}
