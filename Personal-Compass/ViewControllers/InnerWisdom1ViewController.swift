//
//  InnerWisdom1ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/26/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

// Meditation

class InnerWisdom1ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var listenLabel: UILabel!
    
    var currentCompass: Compass! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listenLabel.clipsToBounds = true
        self.listenLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
    }
    
    private func setupView() {
        if let need = self.currentCompass.need {
            self.textView.text = need
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    @IBAction func listenAction(_ sender: UIButton) {
        print("todo")
    }
}

// MARK: - CompassValidation

extension InnerWisdom1ViewController: CompassValidation {
    var error: CompassError? {
        return nil
    }
}

extension InnerWisdom1ViewController: CompassFacetEditor {
    func save() {
        self.currentCompass.lastEditedFacet = .innerWisdom1
    }
}
