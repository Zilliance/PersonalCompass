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
    @IBOutlet fileprivate var titleLable: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        titleLable.text = self.title
        
        titleLable.textColor = UIColor.darkBlue

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
        
        //cell.accessoryView = selectedItems.contains(item) ? UIImageView(image: UIImage(named: "menu-icon")) : nil
        
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
}


extension StressSelectionViewController {
    
    //add a new item logic
    @objc fileprivate func addItemTapped() {
        
        print("todo...")
        
    }
    
}
