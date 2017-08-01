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
    var tableView: UITableView! {get}
    var currentCompass: Compass! {get set}
    var shouldShowFooterHeader: Bool {get set}
    var contentSize: CGSize {get}
    var size: CGSize {get}
}

extension SummaryViewControllerProtocol where Self: UIViewController {

    var contentSize: CGSize {
        var size = self.view.frame.size
        size.height += self.tableView.contentSize.height - self.tableView.frame.size.height
        return size
    }
    
    var size: CGSize {
        return self.view.frame.size
    }

}

class CompassSummaryViewController: UIViewController {
    
    enum SummaryText: String {
        case asseessment = "This is how my thoughts are affecting my emotions, body and behavior:"
        case innerWisdom = "What I have learned about myself:"
    }
    
    @IBOutlet weak var tableContainerView: UIView!
    var compass: Compass!
    var isFinishingCompass = false
    var isFromNotification = false
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var innerWisdomSummaryHeaderView: UIView!
    @IBOutlet weak var assessmentHeaderView: UIView!
    
    @IBOutlet weak var assessmentIcon: UIImageView!
    @IBOutlet weak var assessmentLabel: UILabel!
    
    @IBOutlet weak var innerWisdomLabel: UILabel!
    @IBOutlet weak var innerWisdomIcon: UIImageView!
    
    @IBOutlet weak var waysToFeelBetterLabel: UILabel!
    
    var currentViewController: UIViewController?
    fileprivate var actionSheetHint: OnboardingPopover?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFinishingCompass {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goToHome))
        }
        if isFromNotification {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        }
        
        self.showAssessmentView()
        self.title = compass.stressor
        self.summaryLabel.text = SummaryText.asseessment.rawValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showActionSheetHint()
    }
    
    @objc func goToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareSummaryAction(_ sender: Any) {
        self.generatePDF { [unowned self] (destinationURL,error) in
            
            if let destinationURL = destinationURL {
                
                let activityViewController = UIActivityViewController(activityItems: [destinationURL] , applicationActivities: nil)
                
                self.present(activityViewController,
                                      animated: true,
                                      completion: nil)
            }
            else {
                
                //todo handle errors?
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction fileprivate func showAssessmentView() {
        if let currentViewController = currentViewController, (currentViewController.isKind(of: SummaryViewController.self)) {
            return
        }
        
        self.summaryLabel.text = SummaryText.asseessment.rawValue
        
        let viewController = UIStoryboard(name: "Summary", bundle: nil).instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController

        showViewController(viewController: viewController, innerWisdomImage: UIImage(named: "iconInnerWisdomGrey"), innerWisdomColor: UIColor.silverColor, assessmentImage: UIImage(named: "volunterring"), assessmentColor: UIColor.darkGreyBlue)
        
    }

    @IBAction fileprivate func showInnerWisdomView() {
        
        if let currentViewController = currentViewController, (currentViewController.isKind(of: InnerWisdomSummaryViewController.self)) {
            return
        }
        
        self.summaryLabel.text = SummaryText.innerWisdom.rawValue
        
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
    
    // MARK: - Hint
    
    fileprivate func showActionSheetHint() {
        if !UserDefaults.standard.bool(forKey: "ActionSheetHintShown") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let ss = self, ss.view.window != nil else {
                    return
                }
                
                guard let view = self?.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView, let superview = view.superview else {
                    return
                }
                
                let viewFrame = ss.view.convert(view.frame, from: superview)
                var center = CGPoint(x: viewFrame.midX, y: viewFrame.midY)
                center.y += 10
                
                ss.actionSheetHint = OnboardingPopover()
                
                ss.actionSheetHint?.title = "Save, print or share your action plan: take steps and feel better immediately!"
                ss.actionSheetHint?.hasShadow = true
                ss.actionSheetHint?.shadowColor = UIColor(white: 0, alpha: 0.4)
                ss.actionSheetHint?.arrowLocation = .centeredOnTarget
                ss.actionSheetHint?.present(in: ss.view, at: center, from: .below)
                
                UserDefaults.standard.set(true, forKey: "ActionSheetHintShown")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                    self?.dismissImproveHint()
                }
            }
        }
    }
    
    fileprivate func dismissImproveHint() {
        self.actionSheetHint?.dismiss()
    }
    
    
    @IBAction func showWaysToFeelBetter(_ sender: Any) {
        
        guard let viewController = UIStoryboard(name: "FeelBetter", bundle: nil).instantiateInitialViewController() as? FeelBetterViewController
            else {
                assertionFailure()
                return
        }
        viewController.compass = self.compass
        let navigationController = OrientableNavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)

    }

}


//share functionality

extension CompassSummaryViewController {
    
    func resizeToFitContent() {
        guard let currentVC = currentViewController as? SummaryViewControllerProtocol else {
            return assertionFailure()
        }
        
        //we need to layout the view before getting the current VC content size
        self.view.layoutIfNeeded()

        var newFrame = self.view.frame
        newFrame.size.height += currentVC.contentSize.height - tableContainerView.frame.size.height
        self.view.frame = newFrame

        self.view.layoutIfNeeded()
        
    }
    
    func generatePDF(completion: (URL?, Error?) -> ()) {
        
        let assesmentViewController = UIStoryboard(name: "CompassSummary", bundle: nil).instantiateInitialViewController() as! CompassSummaryViewController
        assesmentViewController.compass = self.compass
        assesmentViewController.view.frame = self.view.frame
        assesmentViewController.showAssessmentView()
        assesmentViewController.resizeToFitContent()
        
        let innerWisdomViewController = UIStoryboard(name: "CompassSummary", bundle: nil).instantiateInitialViewController() as! CompassSummaryViewController
        innerWisdomViewController.compass = self.compass
        innerWisdomViewController.view.frame = self.view.frame
        innerWisdomViewController.showInnerWisdomView()
        innerWisdomViewController.resizeToFitContent()
        
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending((self.compass.stressor ?? "compass") + ".pdf"))
        
        // writes to Disk directly.
        do {
            try PDFGenerator.generate([assesmentViewController.view, innerWisdomViewController.view], to: dst)
            
            print("PDF sample saved in: " + dst.absoluteString)
            completion(dst, nil)
            
        } catch (let error) {
            print(error)
            completion(nil, error)
        }
    }
    
}
