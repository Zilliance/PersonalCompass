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

final class InnerWisdom5ViewController: UIViewController, TableEditableViewController {
        
    @IBOutlet fileprivate var titleLable: UILabel!
    @IBOutlet fileprivate var descriptionLabel: UILabel!
    
    private(set) var tableViewController: ItemsSelectionViewController!
    
    var currentCompass: Compass!
    
    var notificationToken: NotificationToken? = nil
    
    var tableLoaded: ((UIBarButtonItem) -> ())?

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emotionIcon: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
        self.showLearnMoreFirstTime()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.tableLoaded?(self.tableViewController.editButtonItem)
        
    }
    
    private func setupView() {
        
        emotionIcon.image = currentCompass.needMetEmotion?.icon
        emotionLabel.text = (currentCompass.needMetEmotionItems.flatMap { $0.title }).joined(separator: ",\n")
        emotionLabel.textColor = currentCompass.needMetEmotion?.color
        
        self.tableViewController.updateItems(newItems: Array(Database.shared.positiveActivitiesStored))
        
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
            
            itemsSelectionsController.deleteAction = {[unowned self] toDeleteItem in
                
                guard let item = toDeleteItem as? PositiveActivity else {
                    return assertionFailure()
                }
                
                Database.shared.save {
                    if let index = self.currentCompass.positiveActivities.index(of: item) {
                        self.currentCompass.positiveActivities.remove(objectAtIndex: index)
                    }
                }
                
                Database.shared.delete(item)
                                
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
        
        UserDefaults.standard.set(true, forKey: "OtherWaysToFeelBetterHintShown")
        
        exampleViewController.title = "Ways to Feel Better"
        exampleViewController.text = "Having activities that always make you feel better is a powerful tool. Use this list to identify as many activities as possible that allow you to feel the positive emotions you are reaching for."
        
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
