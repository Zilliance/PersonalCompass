//
//  NotificationViewController.swift
//  Personal-Compass
//
//  Created by Philip Dow on 6/28/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    
    var notificationInfo: NotificationInfo? {
        didSet {
            if self.isViewLoaded {
                self.setupView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    private func setupView() {
        // self.titleLabel.text = self.notificationInfo?.title // which is just Personal Compass
        self.textView.text = self.notificationInfo?.body
    }
    
    // MARK: - Actions
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotoCompass(_ sender: Any) {
        let presenting = self.presentingViewController
        let summary = UIStoryboard(name: "CompassSummary", bundle: nil).instantiateInitialViewController() as! CompassSummaryViewController
        
        summary.compass = self.notificationInfo!.compass
        summary.isFromNotification = true
        
        let nav = UINavigationController(rootViewController: summary)
        
        self.dismiss(animated: true, completion: {
            presenting?.present(nav, animated: true, completion: nil)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
