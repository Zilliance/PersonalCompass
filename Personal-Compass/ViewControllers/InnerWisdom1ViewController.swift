//
//  InnerWisdom1ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/26/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import AVFoundation
import MZFormSheetPresentationController

// Meditation

class InnerWisdom1ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var listenLabel: UILabel!
    @IBOutlet weak var headphonesIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var buttonContainerWidthConstraint: NSLayoutConstraint!  // 104
    @IBOutlet weak var buttonContainerHeightConstraint: NSLayoutConstraint! // 130
    
    var currentCompass: Compass!
    
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAudioPlayer()
        self.setupDecriptionLabel()
        
        self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.listenLabel.clipsToBounds = true
        self.listenLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
        
        if UIDevice.isSmallerThaniPhone6 {
            self.buttonContainerWidthConstraint.constant *= 0.8
            self.buttonContainerHeightConstraint.constant *= 0.8
        }
    }
    
    private func setupAudioPlayer() {
        
        let url = URL.init(fileURLWithPath: Bundle.main.path(
            forResource: "mpthreetest",
            ofType: "mp3")!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
        } catch let error as NSError {
            print("audioPlayer error \(error.localizedDescription)")
        }
        
        // background audio
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch let error as NSError {
            print("audio session error \(error.localizedDescription)")
        }
    }
    
    private func setupDecriptionLabel() {
        let text = "Try this two minute meditation to see what your Inner Wisdom has to say about your need.  "
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
    
    private func setupView() {
        if let need = self.currentCompass.need {
            self.textView.text = need
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    @IBAction func listenAction(_ sender: UIButton) {
        if let player = self.audioPlayer {
            
            if !player.isPlaying {
                
                player.play()
                self.listenLabel.text = "Pause"
                self.listenLabel.backgroundColor = .pause
                self.headphonesIcon.image = #imageLiteral(resourceName: "icon-headphones-puase")
            }
            else {
                player.stop()
                self.listenLabel.text = "Listen"
                self.listenLabel.backgroundColor = .purple
                self.headphonesIcon.image = #imageLiteral(resourceName: "icon-headphones-listen")
            }
        }
    }
    
    @IBAction func learnMore(_ sender: Any) {
        guard let exampleViewController = UIStoryboard(name: "ExamplePopUp", bundle: nil).instantiateInitialViewController() as? ExamplePopUpViewController else {
            assertionFailure()
            return
        }
        
        exampleViewController.title = "Your Inner Wisdom"
        exampleViewController.text = "See if your Inner Wisdom agrees with what you need to feel better.\n\nYour Inner Wisdom is your intuition, gut feeling, inner voice or inner knowing. It always knows what's best for you and never needs something outside of your control to change.\n\nTry this 2 minute meditation to see what your Inner Wisdom has to say about what you need to feel better that’s in your control."
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: UIDevice.isSmallerThaniPhone6 ? 260 : 300, height: 400)
        formSheet.contentViewControllerTransitionStyle = .bounce
        self.present(formSheet, animated: true, completion: nil)
    }
}

// MARK: - CompassValidation

extension InnerWisdom1ViewController: CompassValidation {
    var error: CompassError? {
        return nil
    }
}

extension InnerWisdom1ViewController: CompassFacetEditor {
    func save() {
        self.currentCompass.lastEditedFacet = .innerWisdom1
    }
}

extension InnerWisdom1ViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if flag {
            self.listenLabel.text = "Listen"
            self.listenLabel.backgroundColor = .purple
            self.headphonesIcon.image = #imageLiteral(resourceName: "icon-headphones-listen")
        }
        
    }
    
}
