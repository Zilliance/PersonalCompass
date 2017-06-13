//
//  ItemsSelectionViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 17-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import UIKit

final class ItemsSelectionViewController: UITableViewController {
    
    var items: [StringItem] = []
    var selectedItems: [StringItem] = []
    var saveAction: (([StringItem]) -> ())!
    
    var type : StringItem.Type!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell", for: indexPath) as! AddItemCell
            cell.addButton.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StringItemSelectionCell", for: indexPath) as! StringItemSelectionCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel?.text = item.title
        
        cell.selectionImage.image = selectedItems.contains(item) ? UIImage(named: "checkbox-checked"): UIImage(named: "checkbox-unchecked")
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        let index = selectedItems.index(of: item)
        if let index = index {
            selectedItems.remove(at: index)
        }
        else {
            selectedItems.append(item)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateItems(newItems: [StringItem]) {
        self.items = newItems
        self.tableView.reloadData()
    }
    
}


extension ItemsSelectionViewController: CustomStressViewControllerDelegate {
    
    //add a new item logic
    @objc fileprivate func addItemTapped() {
        
        guard let customStressViewController = UIStoryboard(name: "StringItems", bundle: nil).instantiateViewController(withIdentifier: "CustomStress") as? CustomStressViewController
            else {
                assertionFailure()
                return
        }
        
        customStressViewController.type = self.type
        customStressViewController.delegate = self
        
        if (type == BehaviourStress.self) {
            customStressViewController.placeholder = "In one or two words, describe how the situation is affecting your behavior."
            customStressViewController.headerText = "How is the stress of this situation affecting my behavior?"
            customStressViewController.title = "Custom Behavior Stress"
        }
        
        if (type == BodyStress.self) {
            customStressViewController.placeholder = "In one or two words, describe how the situation makes you feel physically."
            customStressViewController.headerText = "How is the stress of this situation affecting me physically?"
            customStressViewController.title = "Custom Body Stress"
        }
        
        if (type == PositiveActivity.self) {
            customStressViewController.placeholder = "In one or two words, describe how else you could feel this emotion."
            customStressViewController.headerText = "How else can I feel this emotion?"
            customStressViewController.title = "Custom Alternative"
        }
        
        let navController = UINavigationController(rootViewController: customStressViewController)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func newItemSaved(newItem: StringItem) {
        
        self.selectedItems.append(newItem)
        
    }
    
}
