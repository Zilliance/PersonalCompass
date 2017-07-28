//
//  FeelBetterItemViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/6/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class FeelBetterItemViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView?
    
    var item: FeelBetterItem?
    
    // MARK: -
    
    @IBAction func showExample(_ sender: Any?) {
        guard let exampleViewController = UIStoryboard(name: "ExamplePopUp", bundle: nil).instantiateInitialViewController() as? ExamplePopUpViewController else {
            assertionFailure()
            return
        }
        
        guard let type = self.item?.type else {
            assertionFailure()
            return
        }
        
        exampleViewController.type = type
        exampleViewController.title = "Example"
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: UIDevice.isSmallerThaniPhone6 ? 260 : 300, height: 400)
        formSheet.contentViewControllerTransitionStyle = .bounce
        self.present(formSheet, animated: true, completion: nil)
        
        exampleViewController.exampleButton.isHidden = true
    }

}
