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
    @IBOutlet var titleLable: UILabel!
    
    var currentSelection: [StressItem] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StressItemSelectionCell", bundle: nil), forCellReuseIdentifier: "StressItemSelectionCell")

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StressItemSelectionCell", for: indexPath) as! AddItemCell
            cell.addButton.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StressItemSelectionCell", for: indexPath) as! StressItemSelectionCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel?.text = item.title
        
        cell.accessoryView = currentSelection.contains(item) ? UIImageView(image: UIImage(named: "menu-icon")) : nil
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        let index = currentSelection.index(of: item)
        if let index = index {
            currentSelection.remove(at: index)
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
