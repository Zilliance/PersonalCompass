//
//  CreateCompassViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/16/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import FXPageControl

class CreateCompassViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pageControl: FXPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    
    private struct CompassItem {
        let viewController: UIViewController
        let scene: CompassScene
    }
    
    private enum CompassScene: String {
        case stressor
        case emotion
        
        var color: UIColor {
            switch self {
            case .stressor:
                return .darkGray
            case .emotion:
                return .red
            }
        }
    }
    
    private var pageCount = 0
    
    private lazy var compassItems: [CompassItem]  = {
        
        var items: [CompassItem] = [
            CompassItem(viewController: self.viewController(for: .stressor), scene: .stressor),
            CompassItem(viewController: self.viewController(for: .emotion), scene: .emotion),
            
        ]
        
        return items
        
    }()
    
    private lazy var pageControlViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.setViewControllers([self.compassItems.first!.viewController], direction: .forward, animated: true, completion: nil)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupView() {
        
        self.topLabel.backgroundColor = .clear
        self.pageControl.dotSize = 12
        self.pageControl.numberOfPages = self.compassItems.count
        self.pageControl.dotColor = .darkGray
        self.pageControl.dotSpacing = 20
        self.pageControl.selectedDotColor = .white
        self.pageControl.dotBorderColor = .darkGray
        self.pageControl.backgroundColor = .clear
        
        self.topLabel.clipsToBounds = true
        self.topLabel.text = CompassScene.stressor.rawValue.capitalized
        self.topLabel.layer.backgroundColor = CompassScene.stressor.color.cgColor
        self.topLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.addChildViewController(self.pageControlViewController)
        self.pageControlViewController.didMove(toParentViewController: self)
        self.pageContainerView.addSubview(self.pageControlViewController.view)
        
        self.pageControlViewController.view.topAnchor.constraint(equalTo: self.pageContainerView.topAnchor).isActive = true
        self.pageControlViewController.view.leadingAnchor.constraint(equalTo: self.pageContainerView.leadingAnchor).isActive = true
        self.pageControlViewController.view.trailingAnchor.constraint(equalTo: self.pageContainerView.trailingAnchor).isActive = true
        self.pageControlViewController.view.bottomAnchor.constraint(equalTo: self.pageContainerView.bottomAnchor).isActive = true
        
        
    }
    
    private func viewController(for scene: CompassScene) -> UIViewController {
    
        return UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController()!
        
    }
    
    private func setupLabel(for scene: CompassScene) {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.topLabel.layer.backgroundColor = scene.color.cgColor
        }) { _ in
            self.topLabel.text = scene.rawValue.capitalized
        }
        
    }
    
    // MARK: - User Actions

    @IBAction func backAction(_ sender: UIButton) {
        guard self.pageCount > 0 else {
            return
        }
        
        self.pageCount -= 1
        
        self.pageControl.currentPage = self.pageCount
        
        let item = self.compassItems[self.pageCount]
        
        self.pageControlViewController.setViewControllers([item.viewController], direction: .reverse, animated: true, completion: nil)
        self.setupLabel(for: item.scene)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        guard self.pageCount < self.compassItems.count - 1 else {
            return
        }
        
        self.pageCount += 1
        
        self.pageControl.currentPage = self.pageCount
        
        let item = self.compassItems[self.pageCount]
        
        self.pageControlViewController.setViewControllers([item.viewController], direction: .forward, animated: true, completion: nil)
        self.setupLabel(for: item.scene)
    }
}

