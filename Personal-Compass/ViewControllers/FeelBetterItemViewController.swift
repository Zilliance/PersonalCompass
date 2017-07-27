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
    @available(*, deprecated)
    @IBOutlet var textView: UITextView?
    @available(*, deprecated)
    var didLayout = false
    
    @IBOutlet var scrollView: UIScrollView?
    
    var item: FeelBetterItem? {
        didSet {
            if let item = self.item {
                self.load(item: item)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = self.item {
            self.load(item: item)
        }
    }

    // MARK: -
    
    @available(*, deprecated)
    func load(item: FeelBetterItem) {
        return ;
        
        guard let scrollView = self.scrollView else {
            return
        }
        
        // Scroll View
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        
        let label = UILabel()
        
        label.font = UIFont.muliRegular(size: 17)
        label.textColor = UIColor.darkBlue
        label.numberOfLines = 0
        label.text = "Doing something that feels good for your body (like going for a walk or taking six deep breaths) is usually the easiest entry point into feeling better because you can almost always take immediate action to impact your body positively.\n\nWhen you do something physical to interrupt the negativity you feel, you will positively impact your thoughts, behaviors, and emotions."
        
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            label.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12),
            label.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 12)
        ])
        
        // Image
        
        // Button
    }
    
    // Fix text view not starting with text at top (!)
    // http://stackoverflow.com/questions/33979214/uitextview-text-starts-from-the-middle-and-not-the-top
    
    @available(*, deprecated)
    override func viewDidLayoutSubviews() {
        if self.didLayout == false {
            self.textView?.setContentOffset(CGPoint.zero, animated: false)
            self.didLayout = true
        }
    }
    
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
