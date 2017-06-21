//
//  InnerWisdom5ViewController.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 01-06-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import RealmSwift
import MZFormSheetPresentationController

// How Else Can I Feel

final class InnerWisdom5ViewController: UIViewController {
    
    @IBOutlet fileprivate var titleLable: UILabel!
    @IBOutlet fileprivate var descriptionLabel: UILabel!
    
    private(set) var tableViewController: ItemsSelectionViewController!
    
    var currentCompass: Compass!
    
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emotionIcon: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
        self.showLearnMoreFirstTime()
    }
    
    private func setupView() {
        emotionIcon.image = currentCompass.needMetEmotion?.icon
        emotionLabel.text = currentCompass.compassNeedMet
        emotionLabel.textColor = currentCompass.needMetEmotion?.color
        
        self.setupDescriptionLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let itemsSelectionsController = segue.destination as? ItemsSelectionViewController {
            
            itemsSelectionsController.type = PositiveActivity.self
            self.tableViewController = itemsSelectionsController
            
            itemsSelectionsController.items = Array(Database.shared.positiveActivitiesStored)
            itemsSelectionsController.selectedItems = Array(self.currentCompass.positiveActivities)
                        
            itemsSelectionsController.saveAction = { selectedItems in
                
                let items = selectedItems.flatMap {
                    return $0 as? PositiveActivity
                }
                
                Database.shared.save {
                    self.currentCompass.positiveActivities.removeAll()
                    self.currentCompass.positiveActivities.append(objectsIn: items)
                }
            }
        }
    }
    
    private func setupDescriptionLabel() {
        let text = "The main goal when working through a stressor is to feel better emotionally.  "
        let learn = "Learn more."
        
        let textAttr = NSAttributedString(string: text, attributes: [
            NSFontAttributeName: UIFont.muliItalic(size: 13),
            NSForegroundColorAttributeName: UIColor.darkBlueText
            ])
        
        let learnAttr = NSAttributedString(string: learn, attributes: [
            NSFontAttributeName: UIFont.muliItalic(size: 13),
            NSForegroundColorAttributeName: UIColor.lightBlue
            ])
        
        let attrString = NSMutableAttributedString()
        attrString.append(textAttr)
        attrString.append(learnAttr)
        
        self.descriptionLabel.attributedText = attrString
    }
    
    fileprivate func showLearnMoreFirstTime() {
        if !UserDefaults.standard.bool(forKey: "OtherWaysToFeelBetterHintShown") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let ss = self, ss.view.window != nil else {
                    return
                }
                
                UserDefaults.standard.set(true, forKey: "OtherWaysToFeelBetterHintShown")
                ss.learnMore(ss)
            }
        }
    }
    
    @IBAction func learnMore(_ sender: Any) {
        guard let exampleViewController = UIStoryboard(name: "ExamplePopUp", bundle: nil).instantiateInitialViewController() as? ExamplePopUpViewController else {
            assertionFailure()
            return
        }
        
        exampleViewController.title = "Ways to Feel Better"
        exampleViewController.text = "The main goal with working through a stressor is to feel better emotionally.\n\nThere are many different ways to feel an emotion. We can, for instance, go for a walk if we want immediate relief from a stressor. Others take time.\n\nWe want you to identify multiple ways to feel better. On this screen, we ask you to think of another way to feel the emotion you want to feel."
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: UIDevice.isSmallerThaniPhone6 ? 260 : 300, height: 400)
        formSheet.contentViewControllerTransitionStyle = .bounce
        self.present(formSheet, animated: true, completion: nil)
    }
}

// MARK: - CompassValidation

extension InnerWisdom5ViewController: CompassValidation {
    var error: CompassError? {
        if let items = self.tableViewController?.selectedItems, items.count > 0 {
            return nil
        } else {
            return .selection
        }
    }
}

// MARK: - CompassFacetEditor

extension InnerWisdom5ViewController: CompassFacetEditor {
    func save() {
        self.tableViewController.saveAction(self.tableViewController.selectedItems)
        self.currentCompass.lastEditedFacet = .innerWisdom5
    }
}
