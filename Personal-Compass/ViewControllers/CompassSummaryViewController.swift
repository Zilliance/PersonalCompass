//
//  CompassSummaryViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 07-06-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import PDFGenerator

protocol SummaryViewControllerProtocol {
    var currentCompass: Compass! {get set}
    var shouldShowFooterHeader: Bool {get set}
}

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
        
        self.title = compass.stressor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction private func showAssessmentView() {
        if let currentViewController = currentViewController, (currentViewController.isKind(of: SummaryViewController.self)) {
            return
        }
        
        let viewController = UIStoryboard(name: "Summary", bundle: nil).instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController

        showViewController(viewController: viewController, innerWisdomImage: UIImage(named: "iconInnerWisdomGrey"), innerWisdomColor: UIColor.silverColor, assessmentImage: UIImage(named: "volunterring"), assessmentColor: UIColor.darkGreyBlue)
        
    }

    @IBAction private func showInnerWisdomView() {
        
        if let currentViewController = currentViewController, (currentViewController.isKind(of: InnerWisdomSummaryViewController.self)) {
            return
        }
        
        let viewController = UIStoryboard(name: "InnerWisdom", bundle: nil).instantiateViewController(withIdentifier: "InnerWisdomSummaryViewController") as! InnerWisdomSummaryViewController
        
        showViewController(viewController: viewController, innerWisdomImage: UIImage(named: "iconInnerWisdomDefault"), innerWisdomColor: UIColor.darkGreyBlue, assessmentImage: UIImage(named: "iconAssessmentGrey"), assessmentColor: UIColor.silverColor)
    }
    
    private func showViewController<T>(viewController: T, innerWisdomImage: UIImage?, innerWisdomColor: UIColor, assessmentImage: UIImage?, assessmentColor: UIColor) where T: UIViewController, T: SummaryViewControllerProtocol {
        
        if let currentViewController = currentViewController {
            
            if (currentViewController.isKind(of: T.self)) {
                return
            }
            
            currentViewController.willMove(toParentViewController: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.didMove(toParentViewController: nil)
            
        }
        var viewController = viewController
        viewController.currentCompass = compass
        viewController.shouldShowFooterHeader = false
        
        viewController.willMove(toParentViewController: self)
        viewController.view.frame = tableContainerView.bounds
        self.addChildViewController(viewController)
        tableContainerView.addSubview(viewController.view)
        
        viewController.didMove(toParentViewController: self)
        
        currentViewController = viewController
        
        innerWisdomIcon.image = innerWisdomImage
        innerWisdomLabel.textColor = innerWisdomColor
        assessmentIcon.image = assessmentImage
        assessmentLabel.textColor = assessmentColor
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        generatePDF()
        
    }
    
    func generatePDF() {
        
        let stressorViewController = UIStoryboard(name: "Stressor", bundle: nil).instantiateInitialViewController() as! StressorViewController
        stressorViewController.currentCompass = self.compass
        stressorViewController.view.frame = self.view.frame
        stressorViewController.view.setNeedsLayout()
        stressorViewController.view.layoutIfNeeded()
        
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("sample1.pdf"))
        
        // writes to Disk directly.
        do {
            try PDFGenerator.generate([stressorViewController.view, self.view], to: dst)
        } catch (let error) {
            print(error)
        }
    }
    
}
