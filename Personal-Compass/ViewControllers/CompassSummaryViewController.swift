//
//  CompassSummaryViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 07-06-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class CompassSummaryViewController: UIViewController {
    @IBOutlet weak var tableContainerView: UIView!
    var compass: Compass!
    
    @IBOutlet weak var innerWisdomSummaryHeaderView: UIView!
    @IBOutlet weak var assessmentHeaderView: UIView!
    
    @IBOutlet weak var assessmentIcon: UIImageView!
    @IBOutlet weak var assessmentLabel: UILabel!
    
    @IBOutlet weak var innerWisdomLabel: UILabel!
    @IBOutlet weak var innerWisdomIcon: UIImageView!
    
    var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        showAssessmentView()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction private func showAssessmentView() {
        
        if let currentViewController = currentViewController {
            
            if (currentViewController.isKind(of: SummaryViewController.self)) {
                return
            }
            
            currentViewController.willMove(toParentViewController: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.didMove(toParentViewController: nil)

        }
        
        let viewController = UIStoryboard(name: "Summary", bundle: nil).instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        viewController.currentCompass = compass
        viewController.shouldShowHeader = false
        
        viewController.willMove(toParentViewController: self)
        viewController.view.frame = tableContainerView.bounds
        self.addChildViewController(viewController)
        tableContainerView.addSubview(viewController.view)
        
        viewController.didMove(toParentViewController: self)
        
        currentViewController = viewController
        
        innerWisdomIcon.image = UIImage(named: "iconInnerWisdomGrey")
        innerWisdomLabel.textColor = UIColor.silverColor
        assessmentIcon.image = UIImage(named: "volunterring")
        assessmentLabel.textColor = UIColor.darkGreyBlue

    }

    @IBAction private func showInnerWisdomView() {
        
        if let currentViewController = currentViewController {
            
            if (currentViewController.isKind(of: InnerWisdomSummaryViewController.self)) {
                return
            }
            
            currentViewController.willMove(toParentViewController: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.didMove(toParentViewController: nil)
            
        }
        
        let viewController = UIStoryboard(name: "InnerWisdom", bundle: nil).instantiateViewController(withIdentifier: "InnerWisdomSummaryViewController") as! InnerWisdomSummaryViewController
        viewController.currentCompass = compass
        viewController.shouldShowHeader = false

        viewController.willMove(toParentViewController: self)
        viewController.view.frame = tableContainerView.bounds
        self.addChildViewController(viewController)
        tableContainerView.addSubview(viewController.view)
        
        viewController.didMove(toParentViewController: self)
        
        currentViewController = viewController
        
        innerWisdomIcon.image = UIImage(named: "iconInnerWisdomDefault")
        innerWisdomLabel.textColor = UIColor.darkGreyBlue
        assessmentIcon.image = UIImage(named: "iconAssessmentGrey")
        assessmentLabel.textColor = UIColor.silverColor
    }
    
}
