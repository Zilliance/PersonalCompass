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
        var compass: Compass = Compass()
        
        init(for scene: CompassScene, compass: Compass) {
            
            switch scene {
            case .body:
                let viewController = UIStoryboard(name: "StressItems", bundle: nil).instantiateViewController(withIdentifier: "CompassStressViewController") as! CompassStressViewController
                viewController.stressItemType = .body
                viewController.currentCompass = compass
                viewController.title = "How is the stress of this situation affecting me physically?"
                self.viewController = viewController
                
            case .behavior:
                let viewController = UIStoryboard(name: "StressItems", bundle: nil).instantiateViewController(withIdentifier: "CompassStressViewController") as! CompassStressViewController
                viewController.title = "How are my thoughts about this situation affecting my behavior?"
                viewController.stressItemType = .behaviour
                viewController.currentCompass = compass
                self.viewController = viewController
                
            case .stressor:
                let viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! StressorViewController
                viewController.currentCompass = compass
                self.viewController = viewController
                
            case .emotion:
                let viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! EmotionViewController
                viewController.currentCompass = compass
                self.viewController = viewController
            
            case .thought:
                let viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! ThoughtViewController
                viewController.currentCompass = compass
                self.viewController = viewController
            }
            
            self.scene = scene
        }
    }
    
    private enum CompassScene: String {
        case stressor
        case emotion
        case thought
        case body
        case behavior
        
        var color: UIColor {
            switch self {
            case .stressor:
                return .darkGray
            case .emotion:
                return .red
            case .thought:
                return .blue
            case .body:
                return .orange
            case .behavior:
                return .green
            }
        }
    }
    
    private var pageCount = 0
    
    private lazy var compassItems: [CompassItem]  = {
        
        var items: [CompassItem] = [
            CompassItem(for: .stressor, compass: self.compass),
            CompassItem(for: .emotion, compass: self.compass),
            CompassItem(for: .thought, compass: self.compass),
            CompassItem(for: .body, compass: self.compass),
            CompassItem(for: .behavior, compass: self.compass),
        ]
        
        return items
        
    }()
    
    private lazy var pageControlViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
             self.pageCount = self.index(for: self.compass.lastEditedFacet)
        controller.setViewControllers([self.compassItems[self.pageCount].viewController], direction: .forward, animated: true, completion: nil)
        self.pageControl.currentPage = self.pageCount
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func index(for lastState: Compass.Facet) -> Int {
        switch lastState {
        case .unknown:
            return 0
        case .stressor:
            return 1
        case .emotion:
            return 2
        default:
            return 0
        }
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
    
    @IBAction func cancelAction(_ sender: Any) {
        
        if !self.compass.completed {
            let user = Database.shared.user
            if let index = user?.compasses.index(of: self.compass) {
                Database.shared.save {
                    user?.compasses.remove(objectAtIndex: index)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

