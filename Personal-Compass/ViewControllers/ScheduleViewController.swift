//
//  ScheduleViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/1/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import SVProgressHUD
import MZFormSheetPresentationController

class ScheduleViewController: UIViewController {

 
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addToCalendarButton: UIButton!
    @IBOutlet weak var setReminderButton: UIButton!
    @IBOutlet weak var exampleButton: UIButton!
    
    private var zillianceTextViewController: ZillianceTextViewController!
    
    var compass: Compass!
    var feelBetterType : FeelBetterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeView))
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //load data
        
//        if let previousInformation = LocalNotificationsHelper.getInformationForStoredNotification(identifier: self.compass.id) {
//            
//            zillianceTextViewController.textView.text = previousInformation.0
//            datePicker.date = previousInformation.1
//            
//        }
        
    }
    
    @objc func closeView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        
        self.title = "Schedule Actions"
        
        // date picker
        
        for view in [self.datePicker] as [UIView] {
            view.layer.cornerRadius = App.Appearance.buttonCornerRadius
            view.layer.borderWidth = App.Appearance.borderWidth
            view.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if let _ = self.feelBetterType {
            self.exampleButton.isHidden = false
        }
    }
    
    // MARK: -- User Actions
    
    private func showErrorNoReminder() {
        let alert = UIAlertController(title: nil, message: "Please enter your reminder", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessHUD(message: String) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMaximumDismissTimeInterval(1.0)
        SVProgressHUD.showSuccess(withStatus: message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.dismiss(animated: true, completion: nil)
        })

    }
    
    @IBAction func exampleAction(_ sender: Any) {
        
        guard let exampleViewController = UIStoryboard(name: "ExamplePopUp", bundle: nil).instantiateInitialViewController() as? ExamplePopUpViewController else {
            assertionFailure()
            return
        }
        
        exampleViewController.type = self.feelBetterType
        
        exampleViewController.doneAction = {[unowned self] text in
            self.zillianceTextViewController.setupForExample(with: text)
        }
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: 300, height: 400)
        formSheet.contentViewControllerTransitionStyle = .bounce
        self.present(formSheet, animated: true, completion: nil)
    }

    @IBAction func addToCalendarAction(_ sender: UIButton) {
        
        guard let body = self.zillianceTextViewController.textView.text, body.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 else {
            
            self.showErrorNoReminder()
            
            return
        }
        
        CalendarHelper.addEvent(with: body, notes: nil, date: self.datePicker.date) { (success, error) in
            
            guard success else {
                switch error {
                case .notGranted?:
                    self.showAlert(title: "Unable to access your calendar", message: "Please enable access calendar in app settings")
                case .errorSavingEvent?:
                    self.showAlert(title: "Unable to Schedule Event", message: "There was an unexpected error saving your event to calendar")
                default:
                    self.showAlert(title: "Unable to Schedule Event", message: "There was an unexpected error saving your event to calendar")

                }
                
                return
            }
            
            self.showSuccessHUD(message: "Added to Calendar")
            
        }

    }
    
    @IBAction func setReminderAction(_ sender: UIButton) {
        
        guard let body = self.zillianceTextViewController.textView.text, body.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 else {
            
            self.showErrorNoReminder()
            
            return
        }
        
        LocalNotificationsHelper.shared.requestAuthorization(inViewController: self) {[unowned self] (authorized) in
            
            if (authorized)
            {
                LocalNotificationsHelper.scheduleLocalNotification(title: "Personal Compass", body: body, date: self.datePicker.date, identifier: self.compass.id)
                
                self.dismiss(animated: true, completion: {
                    self.showSuccessHUD(message: "Set Reminder")

                })
            }
            else
            {
                self.showAlert(title: "Error", message: "Notifications need to be enabled to set a reminder")
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.zillianceTextViewController = segue.destination as! ZillianceTextViewController
        print("")
        if let type = self.feelBetterType {
             self.zillianceTextViewController.feelBetterType = type
        }
        
        self.zillianceTextViewController.compass = self.compass
    }
    
    
}

extension ScheduleViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
