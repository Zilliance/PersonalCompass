//
//  StressSelectionViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 17-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import UIKit

final class StressSelectionViewController: UITableViewController {
    
    var items: [StressItem] = []
    var selectedItems: [StressItem] = []
    var saveAction: (([StressItem]) -> ())!
    
    var type : StressItem.Type!

    override func viewDidLoad() {
        
        super.viewDidLoad()
            
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        saveAction(selectedItems)
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StressItemSelectionCell", for: indexPath) as! StressItemSelectionCell
        
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
    
    func updateItems(newItems: [StressItem]) {
        self.items = newItems
        self.tableView.reloadData()
    }
    
}


extension StressSelectionViewController: CustomStressViewControllerDelegate {
    
    //add a new item logic
    @objc fileprivate func addItemTapped() {
        
        guard let customStressViewController = UIStoryboard(name: "StressItems", bundle: nil).instantiateViewController(withIdentifier: "CustomStress") as? CustomStressViewController
            else {
                assertionFailure()
                return
        }
        
        customStressViewController.type = self.type
        
        customStressViewController.delegate = self
        
        let navController = UINavigationController(rootViewController: customStressViewController)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func newItemSaved(newItem: StressItem) {
        
        self.selectedItems.append(newItem)
        
    }
    
}
