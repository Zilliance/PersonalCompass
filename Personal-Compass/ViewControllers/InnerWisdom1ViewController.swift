//
//  InnerWisdom1ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/26/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import RealmSwift

class InnerWisdom1ViewController: UIViewController, CompassValidation {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var listenLabel: UILabel!
    
    var error: CompassError? = nil
    
    var currentCompass: Compass! 
    
    private var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listenLabel.clipsToBounds = true
        self.listenLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.setupView()
        
        self.notificationToken = self.currentCompass.addNotificationBlock { [unowned self] _ in
            self.setupView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Database.shared.save {
            self.currentCompass.lastEditedFacet = .innerWisdom1
        }
    }

    
    private func setupView() {
        
        if let need = self.currentCompass.need {
            self.textView.text = need
        }
    }
    
    @IBAction func listenAction(_ sender: UIButton) {
        print("todo")
    }
}
