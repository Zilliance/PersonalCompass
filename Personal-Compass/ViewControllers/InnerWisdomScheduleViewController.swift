//
//  InnerWisdomScheduleViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/1/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class InnerWisdomScheduleViewController: UIViewController, CompassFacetEditor, CompassValidation {

    @IBOutlet weak var scheduleLabel: UILabel!
    
    var error: CompassError? = nil
    var currentCompass: Compass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func save() {
        self.currentCompass.lastEditedFacet = .takeAction
    }
    
    private func setupView() {
        
        self.scheduleLabel.clipsToBounds = true
        self.scheduleLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
        
    }

    @IBAction func scheduleAction(_ sender: UIButton) {
        
        guard let viewController = UIStoryboard(name: "Schedule", bundle: nil).instantiateInitialViewController() as? ScheduleViewController
            else {
                assertionFailure()
                return
        }
        viewController.compass = currentCompass
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
