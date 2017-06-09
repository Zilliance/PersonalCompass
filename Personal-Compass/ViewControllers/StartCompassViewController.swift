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
    @IBOutlet weak var greyLineView: UIView!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    static let size = CGSize(width: 105.0, height: 105.0)
    
    var isEditing = true
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.addBorder()
            }
            else {
                self.removeBorder()
            }
        }
    }
    
    private func addBorder() {
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.aquaBlue.cgColor
        self.checkmarkView.alpha = 1
        
    }
    
    private func removeBorder() {
        
        self.contentView.layer.borderWidth = 0
        self.checkmarkView.alpha = 0
        
    }
    
    func setup(for compass: Compass) {
        
        if compass.completed {
            self.completedLabel.backgroundColor = .navBar
            self.completedLabel.textColor = .silverColor
            self.greyLineView.isHidden = true
            self.completedLabel.text = CompassCollectionViewCell.dateFormatter.string(from: compass.dateCreated)
            
        }
            
        else {
            
            self.completedLabel.text = "In progress"
            self.titleLabel.text = compass.stressor
            
        }
    }
    
}

class StartCompassViewController: UIViewController {
    
    @IBOutlet weak var startCompassButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topOverlay: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButtonContainer: UIView!
    
    fileprivate var isDeleting = false
    
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
        self.editButton.title = "Edit"
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CompassCollectionViewCell.size
        self.collectionView.collectionViewLayout = layout
        self.collectionView.allowsMultipleSelection = true
        self.startCompassButton.layer.cornerRadius = App.Appearance.buttonCornerRadius
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    private func toogleDeleteMode() {
        self.isDeleting = !self.isDeleting
        self.editButton.title = self.isDeleting ? "Cancel" : "Edit"
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topOverlay.alpha = self.isDeleting ? 0.6 : 0
            self.deleteButtonContainer.alpha = self.isDeleting ? 1 : 0
        }) { (complete) in
            
        }
    }
    
    // MARK: -- User Actions
    
    @IBAction func startAction(_ sender: UIButton) {
        let compass = Compass()
        
        guard let createCompassViewController = UIStoryboard(name: "CreateCompass", bundle: nil).instantiateInitialViewController() as? CreateCompassViewController else { return }
        createCompassViewController.compass = compass
        self.navigationController?.pushViewController(createCompassViewController, animated: true)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        self.sideMenuController?.toggle()
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        self.toogleDeleteMode()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        if let indexes = self.collectionView.indexPathsForSelectedItems {
            
            let alertController = UIAlertController(title: "Are you sure you want to delete the selected compasses?", message: "Deleting them will permanently remove them.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                alertController.dismiss(animated: true, completion: nil)
                
               self.collectionView.performBatchUpdates({
                
                var compassesToDelete: [Compass] = []
                for index in indexes {
                    compassesToDelete.append(self.compasses[index.row])
                }
                
                for compass in compassesToDelete {
                    Database.shared.delete(compass)
                }

                self.collectionView.deleteItems(at: indexes)
               }, completion: nil)
                
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
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
        
        guard !self.isDeleting else {
            return
        }
        
        let compass = self.compasses[indexPath.row]
        
        if !compass.completed {
            guard let createCompassViewController = UIStoryboard(name: "CreateCompass", bundle: nil).instantiateInitialViewController() as? CreateCompassViewController else { return }
            createCompassViewController.compass = Compass(value: compass)
            self.navigationController?.pushViewController(createCompassViewController, animated: true)
        }
        
        else {
            guard let compassSummaryViewController = UIStoryboard(name: "CompassSummary", bundle: nil).instantiateInitialViewController() as? CompassSummaryViewController else { return assertionFailure() }
            
            compassSummaryViewController.compass = compass
            self.navigationController?.pushViewController(compassSummaryViewController, animated: true)
            
        }

        
    }
}
