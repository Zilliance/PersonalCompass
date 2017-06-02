//
//  InnerWisdom1ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/26/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class InnerWisdom1ViewController: UIViewController, CompassValidation, CompassFacetEditor {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var listenLabel: UILabel!
    
    var error: CompassError? = nil
    
    var currentCompass: Compass! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listenLabel.clipsToBounds = true
        self.listenLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
        
    }
    
    func save() {
         self.currentCompass.lastEditedFacet = .innerWisdom1
    }
    
    private func setupView() {
        
        if let need = self.currentCompass.need {
            self.textView.text = need
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    @IBAction func listenAction(_ sender: UIButton) {
        print("todo")
    }
}
