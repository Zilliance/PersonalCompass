//
//  IntroViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/21/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageHeightContraint: NSLayoutConstraint!
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if UIDevice.isSmallerThaniPhone6 {
            self.imageHeightContraint.constant = 175
            self.textView.font = UIFont.muliSemiBold(size: 14)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
        
    }


    @IBAction func continueAction(_ sender: UIButton) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let sideMenuViewController = CustomSideViewController()
        sideMenuViewController.setupStartCompass()
        
        sideMenuViewController.view.frame = rootViewController.view.frame
        sideMenuViewController.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = sideMenuViewController
        }, completion: nil)
        
    }
}
