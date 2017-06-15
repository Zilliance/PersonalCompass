//
//  InnerWisdom1ViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/26/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import AVFoundation

// Meditation

class InnerWisdom1ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var listenLabel: UILabel!
    
    var currentCompass: Compass!
    
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAudioPlayer()
        self.listenLabel.clipsToBounds = true
        self.listenLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
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
            }
            else {
                player.stop()
                self.listenLabel.text = "Listen"
            }
        }
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
        }
        
    }
    
}
