//
//  CustomStressViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/25/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol CustomStressViewControllerDelegate: class {
    func newItemSaved(newItem: StringItem)
}

final class CustomStressViewController: UIViewController {
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topSubheading: UILabel!
    
    var type: StringItem.Type!
    weak var delegate: CustomStressViewControllerDelegate!
    
    var headerText: String!
    
    var placeholder: String! {
        didSet {
            if self.isViewLoaded {
                self.textView.placeholder = placeholder
            }
        }
    }
    
    fileprivate let placeholderTextColor = UIColor.lightGray
    fileprivate let normalTextColor = UIColor.darkGray

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.textView.becomeFirstResponder()
    }
    
    private func setupView() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.save))
        
        self.textView.placeholder = self.placeholder
        self.topLabel.text = self.headerText
        
        self.textView.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.textView.layer.borderWidth = App.Appearance.borderWidth
        self.textView.layer.borderColor = UIColor.lightGray.cgColor

        self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension CustomStressViewController {
    
    @objc func closeView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        
        guard self.textView.text.characters.count > 0 else {
            self.showAlert(title: "Please enter text", message: "")
            return
        }
        
        let newItem = self.type.createNew(title: textView.text)
        self.delegate.newItemSaved(newItem: newItem)
        
        self.dismiss(animated: true, completion: nil)
    }

}

extension CustomStressViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
