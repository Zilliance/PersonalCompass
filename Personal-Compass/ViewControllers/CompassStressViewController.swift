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

final class CompassStressViewController: UIViewController {
    
    @IBOutlet fileprivate var titleLable: UILabel!
    
    var currentCompass: Compass!
    
    var stressItemType: StressType = .body

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.titleLable.text = self.title
        
        self.titleLable.textColor = UIColor.darkBlue
        
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
            
            if (self.stressItemType == .body) {
                
                self.setupItemsSelection(vc: itemsSelectionsController, preloadedItems: Array(Database.shared.bodyStressStored), destination: self.currentCompass.bodyStressElements)

            }
            else {
                
                self.setupItemsSelection(vc: itemsSelectionsController, preloadedItems: Array(Database.shared.behaviourStressStored), destination: self.currentCompass.behaviourStressElements)
                
            }
            
            
        }
        
    }
    
}
