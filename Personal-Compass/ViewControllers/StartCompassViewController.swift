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
    
    fileprivate let compasses = ["Compass 1", "Compass 2", "Compass 3", "Compass 4", "Compass 5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.title = "Personal Compass"
        self.startCompassButton.layer.cornerRadius = App.Appearance.buttonCornerRadius
    }
    
    // MARK: -- User Actions
    
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
        let title = self.compasses[indexPath.row]
        
        cell.titleLabel.text = title
        
        return cell
    }
}

extension StartCompassViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
