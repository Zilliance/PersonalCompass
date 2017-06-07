//
//  AutoscrollableViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 07-06-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation

import UIKit

class AutoscrollableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let editingView = self.view.subviews.filter {
            $0.isFirstResponder == true
            }.first
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, let editingView = editingView {
            
            let diff = self.view.frame.size.height - editingView.frame.size.height - editingView.frame.origin.y - keyboardSize.height
            
            if (diff < 0) {
                
                self.view.frame.origin.y = max(self.view.frame.origin.y + diff, self.view.frame.origin.y - editingView.frame.origin.y)
                
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
}
