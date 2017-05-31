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
    @IBOutlet weak var completedLabel: UILabel!
    
    static let size = CGSize(width: 105.0, height: 105.0)
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    func setup(for compass: Compass) {
        
        if compass.completed {
            self.completedLabel.backgroundColor = .navBar
            self.completedLabel.textColor = .softWhite
            
            self.completedLabel.text = CompassCollectionViewCell.dateFormatter.string(from: compass.dateCreated)
            
        }
            
        else {
            
            self.completedLabel.text = "In progress"
            self.titleLabel.text = compass.stressor
            
            self.completedLabel.layer.borderColor = UIColor.paleGrey.cgColor
            self.completedLabel.layer.borderWidth = 1.0
        }
    }
    
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
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CompassCollectionViewCell.size
        self.collectionView.collectionViewLayout = layout
        self.startCompassButton.layer.cornerRadius = App.Appearance.buttonCornerRadius
    }
    
    // MARK: -- User Actions
    
    @IBAction func startAction(_ sender: UIButton) {
        let compass = Compass()
        compass.lastEditedFacet = .unknown
        
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
        cell.setup(for: compass)
    
        return cell
    }
}

extension StartCompassViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let compass = self.compasses[indexPath.row]
        
        if !compass.completed {
            guard let createCompassViewController = UIStoryboard(name: "CreateCompass", bundle: nil).instantiateInitialViewController() as? CreateCompassViewController else { return }
            createCompassViewController.compass = Compass(value: compass)
            self.navigationController?.pushViewController(createCompassViewController, animated: true)
        }
        
        else {
            //go to summary
        }

        
    }
}
