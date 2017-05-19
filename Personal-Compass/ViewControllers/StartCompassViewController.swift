//
//  StartCompassViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/15/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class CompassCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}

class StartCompassViewController: UIViewController {
    
    @IBOutlet weak var startCompassButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var compasses: [Compass] {
        return Array(Database.shared.user.compasses)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.collectionView.reloadData()
    }
    
    private func setupView() {
        self.title = "Personal Compass"
        self.startCompassButton.layer.cornerRadius = App.Appearance.buttonCornerRadius
    }
    
    // MARK: -- User Actions
    
    @IBAction func startAction(_ sender: UIButton) {
        let compass = Compass()
        let user = Database.shared.user
        Database.shared.save {
            user?.compasses.append(compass)
        }
        guard let createCompassViewController = UIStoryboard(name: "CreateCompass", bundle: nil).instantiateInitialViewController() as? CreateCompassViewController else { return }
        createCompassViewController.compass = compass
        self.navigationController?.pushViewController(createCompassViewController, animated: true)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        self.sideMenuController?.toggle()
    }

}

extension StartCompassViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.compasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "compassCell", for: indexPath) as! CompassCollectionViewCell
        let compass = self.compasses[indexPath.row]
        
        cell.titleLabel.text = compass.completed ? "completed" : "incomplete"
        
        return cell
    }
}

extension StartCompassViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let compass = self.compasses[indexPath.row]
        
        if !compass.completed {
            guard let createCompassViewController = UIStoryboard(name: "CreateCompass", bundle: nil).instantiateInitialViewController() as? CreateCompassViewController else { return }
            createCompassViewController.compass = compass
            self.navigationController?.pushViewController(createCompassViewController, animated: true)
        }
        
        else {
            //go to summary
        }

        let stressConfigurationVC = UIStoryboard(name: "StressItems", bundle: nil).instantiateViewController(withIdentifier: "CompassStressViewController") as! CompassStressViewController
        
        stressConfigurationVC.title = "This is a test to see how the title looks"
        
        stressConfigurationVC.stressItemType = .behaviour
        
        stressConfigurationVC.currentCompass = Compass()
        
        self.navigationController?.pushViewController(stressConfigurationVC, animated: true)
        
    }
}
