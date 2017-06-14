//
//  ExamplePopUpViewController.swift
//  Zilliance
//
//  Created by ricardo hernandez  on 5/8/17.
//  Copyright © 2017 Pillars4Life. All rights reserved.
//

import UIKit

class ExamplePopUpViewController: UIViewController {
    
    var doneAction: ((String) -> ())?
    var type: FeelBetterType?
    
    private var text = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exampleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.titleLabel.text = "Example"
        if let type = self.type {
            
            switch type {
            case .body:
                self.text = "My children always push my buttons in the morning. To find relief from this stressor, I will go for a run before they wake up."
            case .thought:
                self.text =  "Instead of thinking, \"I wasted a decade of my life on a bad marriage,\" I can think, \"I was married for a decade, and when the marriage dissolved, I identified a few things about myself that could be improved upon. These days, I’m much more upfront and direct about my communication, and I ask the same from my romantic partners.\""
            case .behavior:
                self.text = "Waiting for example text"
            case .emotion:
                self.text = "When I feel triggered by my spouse, I will take a few minutes to myself and listen to my favorite song before re-engaging."
            }
        }
        self.exampleTextView.text = self.text
    }
    
    //MARK - User Actions

    @IBAction func okAction(_ sender: Any) {
        self.doneAction?(self.text)
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func closeAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
}
