//
//  FeelBetterViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/5/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

struct FeelBetterItem {
    let title: String
    let image: UIImage
    let viewController: UIViewController
    let type : FeelBetterType
    
    var selectedColor: UIColor {
        switch self.type {
        case .body:
            return UIColor.color(forRed: 255, green: 184, blue: 55, alpha: 1)
        case .thought:
            return UIColor.color(forRed: 0, green: 184, blue: 231, alpha: 1)
        case .behavior:
            return UIColor.color(forRed: 101, green: 175, blue: 71, alpha: 1)
        case .emotion:
            return UIColor.color(forRed: 235, green: 91, blue: 67, alpha: 1)
        }
    }
}

extension FeelBetterItem {
    static var body: FeelBetterItem = FeelBetterItem(title: "Body", image: #imageLiteral(resourceName: "icon-body-default"), viewController: UIStoryboard(name: "FeelBetterItems", bundle: nil).instantiateViewController(withIdentifier: "body") , type: .body)
    static var thought: FeelBetterItem = FeelBetterItem(title: "Thought", image: #imageLiteral(resourceName: "icon-thought-default"), viewController: UIStoryboard(name: "FeelBetterItems", bundle: nil).instantiateViewController(withIdentifier: "thought") , type: .thought)
    static var behavior: FeelBetterItem = FeelBetterItem(title: "Behavior", image: #imageLiteral(resourceName: "icon-behavior-default"), viewController: UIStoryboard(name: "FeelBetterItems", bundle: nil).instantiateViewController(withIdentifier: "behavior") , type: .behavior)
    static var emotion: FeelBetterItem = FeelBetterItem(title: "Emotion", image: #imageLiteral(resourceName: "icon-emotion-default"), viewController: UIStoryboard(name: "FeelBetterItems", bundle: nil).instantiateViewController(withIdentifier: "emotion") , type: .emotion)
}

enum FeelBetterType: String {
    case body
    case thought
    case behavior
    case emotion
}

final class FeelBetterItemCell: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var item: FeelBetterItem = .body {
        didSet {
            self.label.text = item.title
            self.imageView.image = item.image.tinted(color: self.isSelected ? item.selectedColor: .navBar)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //rounded image
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        
        if UIDevice.isSmallerThaniPhone6 {
            label.font = UIFont.muliRegular(size: 12)
        }
    }
    
    
    
    override var isSelected: Bool {
        didSet {
            self.imageView.image = self.item.image.tinted(color: isSelected ? self.item.selectedColor : .navBar)
            self.label.textColor = isSelected ? self.item.selectedColor : .navBar
            
            
        }
    }
}

class FeelBetterViewController: UIViewController {
    
    @IBOutlet weak var scheduleItButton: UIButton!
    @IBOutlet weak var vcContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var currentViewController: UIViewController?
    
    var compass: Compass!
    
    fileprivate var items: [FeelBetterItem]!
    
    fileprivate var currentIndex = 0
    
    private let feelBetterItems: [FeelBetterItem] = [.body, .thought, .behavior, .emotion]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.compass.stressor!
        
        self.scheduleItButton.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.scheduleItButton.backgroundColor = FeelBetterItem.body.selectedColor
        
        self.items = self.feelBetterItems
        self.showViewController(controller: items[0].viewController)
        
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeView))
        
        // pre select first position
        self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
    }
    
    @objc func closeView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func showViewController(controller: UIViewController) {
        if (self.currentViewController != nil)
        {
            self.currentViewController?.willMove(toParentViewController: nil)
            self.currentViewController?.view.removeFromSuperview()
            self.currentViewController?.didMove(toParentViewController: nil)
        }
        
        controller.willMove(toParentViewController: self)
        self.vcContainerView.addSubview(controller.view)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: self.vcContainerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: self.vcContainerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: self.vcContainerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: self.vcContainerView.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
        
        self.currentViewController = controller
    }
    
    
    @IBAction func scheduleItAction(_ sender: UIButton) {
        
        guard let viewController = UIStoryboard(name: "Schedule", bundle: nil).instantiateInitialViewController() as? ScheduleViewController
            else {
                assertionFailure()
                return
        }
        
        viewController.compass = self.compass
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)

        
    }
    
}

extension FeelBetterViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feelBetterItemCell", for: indexPath) as! FeelBetterItemCell
        let item = self.items[indexPath.row]
    
        cell.item = item
        
        return cell
    }
}


extension FeelBetterViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        //change view controller.
        let item = self.items[indexPath.row]
        let newViewController = item.viewController
        
        self.scheduleItButton.backgroundColor = item.selectedColor
        
        
        if (newViewController != currentViewController)
        {
            self.showViewController(controller: newViewController)
        }
        
        self.currentIndex = indexPath.row
    }
    
}

extension FeelBetterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemRatio = UIDevice.isSmallerThaniPhone6 ? self.items.count + 1 : self.items.count
        return CGSize(width: collectionView.bounds.size.width / CGFloat(itemRatio) , height: 84)
    }
    
}

