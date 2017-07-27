//
//  FeelBetterViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/5/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

struct FeelBetterItem {
    let title: String
    let image: UIImage
    let viewController: FeelBetterItemViewController
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
    static var body: FeelBetterItem = {
        let item = FeelBetterItem(title: "Body", image: #imageLiteral(resourceName: "icon-body-default"), viewController: UIStoryboard(name: "FeelBetterItems", bundle: nil).instantiateViewController(withIdentifier: "body") as! FeelBetterItemViewController, type: .body)
        item.viewController.item = item
        return item
    }()
    static var thought: FeelBetterItem = {
        let item = FeelBetterItem(title: "Thought", image: #imageLiteral(resourceName: "icon-thought-default"), viewController: UIStoryboard(name: "FeelBetterItems", bundle: nil).instantiateViewController(withIdentifier: "thought") as! FeelBetterItemViewController, type: .thought)
        item.viewController.item = item
        return item
    }()
    static var behavior: FeelBetterItem = {
        let item = FeelBetterItem(title: "Behavior", image: #imageLiteral(resourceName: "icon-behavior-default"), viewController: UIStoryboard(name: "FeelBetterItems", bundle: nil).instantiateViewController(withIdentifier: "behavior") as! FeelBetterItemViewController, type: .behavior)
        item.viewController.item = item
        return item
    }()
    static var emotion: FeelBetterItem = {
        let item = FeelBetterItem(title: "Emotion", image: #imageLiteral(resourceName: "icon-emotion-default"), viewController: UIStoryboard(name: "FeelBetterItems", bundle: nil).instantiateViewController(withIdentifier: "emotion")as! FeelBetterItemViewController, type: .emotion)
        item.viewController.item = item
        return item
    }()
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
            self.imageView.image = item.image.tinted(color: self.isSelected ? .navBar : .white)
            self.contentView.backgroundColor = self.isSelected ? .contentBackground : item.selectedColor
            self.label.textColor = self.isSelected ? .navBar : .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.isSmallerThaniPhone6 {
            label.font = UIFont.muliRegular(size: 12)
        }
    }
    
    
    
    override var isSelected: Bool {
        didSet {
            self.imageView.image = self.item.image.tinted(color: isSelected ? .navBar : .white)
            self.contentView.backgroundColor = isSelected  ? .contentBackground : self.item.selectedColor
            self.label.textColor = isSelected ? .navBar : .white
            
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
        
        self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLearnMoreFirstTime()
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
        viewController.feelBetterType = self.feelBetterItems[self.currentIndex].type
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Popup
    
    fileprivate func showLearnMoreFirstTime() {
        if !UserDefaults.standard.bool(forKey: "WaysToFeelBetterHintShown") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let ss = self, ss.view.window != nil else {
                    return
                }
                
                UserDefaults.standard.set(true, forKey: "WaysToFeelBetterHintShown")
                ss.learnMore(ss)
            }
        }
    }
    
    @IBAction func learnMore(_ sender: Any) {
        guard let exampleViewController = UIStoryboard(name: "ExamplePopUp", bundle: nil).instantiateInitialViewController() as? ExamplePopUpViewController else {
            assertionFailure()
            return
        }
        
        UserDefaults.standard.set(true, forKey: "WaysToFeelBetterHintShown")
        
        exampleViewController.title = "Ways To Feel Better"
        exampleViewController.text = "You can feel better by doing something positive in any of these four areas - your body, thoughts, behavior or emotions - even if you can’t eliminate your stressor."
        
        let formSheet = MZFormSheetPresentationViewController(contentViewController: exampleViewController)
        formSheet.presentationController?.contentViewSize = CGSize(width: UIDevice.isSmallerThaniPhone6 ? 260 : 300, height: 300)
        formSheet.contentViewControllerTransitionStyle = .bounce
        self.present(formSheet, animated: true, completion: nil)
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
        return CGSize(width: UIScreen.main.bounds.width / CGFloat(self.items.count) , height: 84)
    }
}

