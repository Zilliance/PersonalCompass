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
    
    fileprivate let sections = ["Emotion", "Thought", "Body", "Behavior", "Inner Wisdom"]
    
    fileprivate lazy var pageControlViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.delegate = self
        controller.dataSource = self
        controller.setViewControllers([UIViewController()], direction: .forward, animated: true, completion: nil)
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
        
        self.pageControl.dotSize = 12
        self.pageControl.numberOfPages = sections.count
        self.pageControl.dotColor = .darkGray
        self.pageControl.dotSpacing = 20
        self.pageControl.selectedDotColor = .white
        self.pageControl.dotBorderColor = .darkGray
        self.pageControl.backgroundColor = .clear
        
        self.topLabel.clipsToBounds = true
        self.topLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.addChildViewController(self.pageControlViewController)
        self.pageContainerView.addSubview(self.pageControlViewController.view)
    }
    
    // MARK: - User Actions

    @IBAction func nextAction(_ sender: UIButton) {
        self.pageControl.currentPage += 1
    }
}

extension CreateCompassViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        return nil
    }
    
}
