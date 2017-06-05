//
//  ScheduleViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/1/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import SVProgressHUD

class ScheduleViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addToCalendarButton: UIButton!
    @IBOutlet weak var setReminderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeView))
        self.setupView()
    }
    
    @objc func closeView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        
        self.title = "Schedule actions"
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        // date picker
        
        for view in [self.datePicker, self.textView] as [UIView] {
            view.layer.cornerRadius = App.Appearance.buttonCornerRadius
            view.layer.borderWidth = App.Appearance.borderWidth
            view.layer.borderColor = UIColor.lightGray.cgColor
        }
        
    }
    
    // MARK: -- User Actions

    @IBAction func addToCalendarAction(_ sender: UIButton) {
        
        guard let body = self.textView.text, body.characters.count > 0 else {
            
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
            
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setMaximumDismissTimeInterval(1.0)
            SVProgressHUD.showSuccess(withStatus: "The reminder has been added to your calendar")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }

    }
    
    @IBAction func setReminderAction(_ sender: UIButton) {
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
