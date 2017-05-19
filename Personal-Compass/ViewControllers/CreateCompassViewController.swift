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
    
    var compass: Compass = Compass()
    
    private struct CompassItem {
        let viewController: UIViewController
        let scene: CompassScene
        
        init(for scene: CompassScene) {
            self.viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController()!
            self.scene = scene
        }
    }
    
    private enum CompassScene: String {
        case stressor
        case emotion
        case thought
        
        var color: UIColor {
            switch self {
            case .stressor:
                return .darkGray
            case .emotion:
                return .red
            case .thought:
                return .blue
            }
        }
    }
    
    private var pageCount = 0
    
    private lazy var compassItems: [CompassItem]  = {
        
        var items: [CompassItem] = [
            CompassItem(for: .stressor),
            CompassItem(for: .emotion),
            CompassItem(for: .thought),
        ]
        
        return items
        
    }()
    
    private lazy var pageControlViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageCount = self.index(for: self.compass.lastEditedFacet) + 1
        controller.setViewControllers([self.compassItems[self.pageCount].viewController], direction: .forward, animated: true, completion: nil)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func index(for lastState: Compass.Facet) -> Int {
        switch lastState {
        case .stressor:
            return 0
        case .emotion:
            return 1
        default:
            return 0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.loadCompassData()
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
    
    private func setupLabel(for scene: CompassScene) {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.topLabel.layer.backgroundColor = scene.color.cgColor
        }) { _ in
            self.topLabel.text = scene.rawValue.capitalized
        }
        
    }
    
    private func saveCompass() {
        let compassItem = self.compassItems[self.pageCount]
        switch compassItem.scene {
        case .stressor:
            if let viewController = compassItem.viewController as? StressorViewController {
                Database.shared.save {
                    self.compass.stressor = viewController.textView.text
                    self.compass.lastEditedFacet = .stressor
                }
            }
        default:
            break
        }
    }
    
    private func loadCompassData() {
        let compassItem = self.compassItems[self.pageCount]
        switch compassItem.scene {
        case .stressor:
            if let viewController = compassItem.viewController as? StressorViewController {
                viewController.textView.text = self.compass.stressor
            }
        default:
            break
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
        
        self.saveCompass()

        self.pageCount += 1
        
        self.pageControl.currentPage = self.pageCount
        
        let item = self.compassItems[self.pageCount]
        
        self.pageControlViewController.setViewControllers([item.viewController], direction: .forward, animated: true, completion: nil)
        self.setupLabel(for: item.scene)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.saveCompass()
        self.navigationController?.popViewController(animated: true)
    }
    
}

