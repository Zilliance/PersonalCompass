//
//  CreateCompassViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/16/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class CreateCompassViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    
    let sections = ["Emotion", "Thought", "Body", "Behavior", "Inner Wisdom"]
    
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
        self.topLabel.clipsToBounds = true
        self.topLabel.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.addChildViewController(self.pageControlViewController)
        self.pageContainerView.addSubview(self.pageControlViewController.view)
    }
    
    // MARK: - User Actions

    @IBAction func nextAction(_ sender: UIButton) {
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
