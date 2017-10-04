//
//  InnerWisdomScheduleViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/1/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

//  Completed

import UIKit

class InnerWisdomScheduleViewController: UIViewController, CompassFacetEditor, CompassValidation {

    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var buttonContainerWidthConstraint: NSLayoutConstraint!  // 104
    @IBOutlet weak var buttonContainerHeightConstraint: NSLayoutConstraint! // 130
    
    var done: (() -> ())?
    
    var error: CompassError? = nil
    var currentCompass: Compass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func save() {
        self.currentCompass.lastEditedFacet = .takeAction
        self.currentCompass.completed = true
        Analytics.shared.send(event: PersonalCompassAnalytics.PersonalCompassEvent.compassCompleted)
    }
    
    private func setupView() {
        self.scheduleLabel.clipsToBounds = true
        self.scheduleLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
        
        if UIDevice.isSmallerThaniPhone6 {
            // self.buttonContainerWidthConstraint.constant *= 0.8
            self.buttonContainerHeightConstraint.constant *= 0.8
        }
    }

    @IBAction func scheduleAction(_ sender: UIButton) {
        
        guard let viewController = UIStoryboard(name: "Schedule", bundle: nil).instantiateInitialViewController() as? ScheduleViewController
            else {
                assertionFailure()
                return
        }
        viewController.compass = currentCompass
        let navigationController = OrientableNavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func tellMeMoreAction(_ sender: UIButton) {
        
        guard let viewController = UIStoryboard(name: "FeelBetter", bundle: nil).instantiateInitialViewController() as? FeelBetterViewController
            else {
                assertionFailure()
                return
        }
        viewController.compass = self.currentCompass
        let navigationController = OrientableNavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        self.done?()
        
        guard let compassSummaryViewController = UIStoryboard(name: "CompassSummary", bundle: nil).instantiateInitialViewController() as? CompassSummaryViewController else { return assertionFailure() }
        
        compassSummaryViewController.compass = self.currentCompass
        compassSummaryViewController.isFinishingCompass = true
        self.navigationController?.pushViewController(compassSummaryViewController, animated: true)
        
    }
}
