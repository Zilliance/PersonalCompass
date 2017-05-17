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
    
    private enum CompassScene: String {
        case stressor
    }
    
    fileprivate(set) lazy var viewControllers: [UIViewController]  = {
        
        var viewControllers: [UIViewController] = [
            self.viewController(for: .stressor),
            ]
        
        return viewControllers
        
    }()
    
    fileprivate lazy var pageControlViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.delegate = self
        controller.setViewControllers([self.viewControllers.first!], direction: .forward, animated: true, completion: nil)
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
        self.pageControl.numberOfPages = self.viewControllers.count
        self.pageControl.dotColor = .darkGray
        self.pageControl.dotSpacing = 20
        self.pageControl.selectedDotColor = .white
        self.pageControl.dotBorderColor = .darkGray
        self.pageControl.backgroundColor = .clear
        
        self.topLabel.clipsToBounds = true
        self.topLabel.text = CompassScene.stressor.rawValue.capitalized
        self.topLabel.layer.backgroundColor = UIColor.red.cgColor
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
    
    // MARK: - User Actions

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.pageControl.currentPage += 1
        UIView.animate(withDuration: 0.3) { 
            self.topLabel.layer.backgroundColor = UIColor.green.cgColor
        }
    }
}

extension CreateCompassViewController: UIPageViewControllerDelegate {
    
    
}
