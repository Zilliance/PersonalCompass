//
//  CreateCompassViewController.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 5/16/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import FXPageControl

protocol CompassValidation {
    var error: CompassError? { get }
    var currentCompass: Compass! { get set }
}

enum CompassError {
    case text
    case selection
}

enum CompassScene: String {
    case stressor
    case emotion
    case thought
    case body
    case behavior
    case assessment
    case need
    
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
        case .assessment:
            return .green
        case .need:
            return .purple
        }
    }
    
}

class CreateCompassViewController: UIViewController {
    
    fileprivate struct CompassItem {
        let viewController: UIViewController
        let scene: CompassScene
        
        init(for scene: CompassScene, container: CreateCompassViewController) {
            
            switch scene {
            case .body:
                let viewController = UIStoryboard(name: "StressItems", bundle: nil).instantiateViewController(withIdentifier: "CompassStressViewController") as! CompassStressViewController
                viewController.stressItemType = BodyStress.self
                viewController.currentCompass = container.compass
                viewController.title = "How is the stress of this situation affecting me physically?"
                self.viewController = viewController
                
            case .behavior:
                let viewController = UIStoryboard(name: "StressItems", bundle: nil).instantiateViewController(withIdentifier: "CompassStressViewController") as! CompassStressViewController
                viewController.title = "How are my thoughts about this situation affecting my behavior?"
                viewController.stressItemType = BehaviourStress.self
                viewController.currentCompass = container.compass
                self.viewController = viewController
                
            case .stressor:
                let viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! StressorViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController
                
            case .emotion:
                let viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! EmotionViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController
                
            case .thought:
                let viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! ThoughtViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController

            case .assessment:
                let viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! AssessmentViewController
                viewController.currentCompass = container.compass
                viewController.delegate = container
                self.viewController = viewController
                
            case .need:
                let viewController = UIStoryboard(name: scene.rawValue.capitalized, bundle: nil).instantiateInitialViewController() as! NeedViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController
            }
            
            self.scene = scene
        }
    }
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pageControl: FXPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    
    var compass: Compass = Compass()

    private var pageCount = 0
    
    fileprivate lazy var compassItems: [CompassItem]  = {
        
        var items: [CompassItem] = [
            CompassItem(for: .stressor, container: self),
            CompassItem(for: .emotion, container: self),
            CompassItem(for: .thought, container: self),
            CompassItem(for: .body, container: self),
            CompassItem(for: .behavior, container: self),
            CompassItem(for: .assessment, container: self),
            CompassItem(for: .need, container: self),
        ]
        
        return items
        
    }()
    
    private lazy var pageControlViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
             self.pageCount = self.compass.lastEditedFacet.pageIndex
        controller.setViewControllers([self.compassItems[self.pageCount].viewController], direction: .forward, animated: true, completion: nil)
        self.pageControl.currentPage = self.pageCount
        self.setupLabel(for: self.compassItems[self.pageCount].scene)
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
    
    private func checkError() -> CompassError? {
        let vc = self.compassItems[self.pageCount].viewController as! CompassValidation
        return vc.error
    }
    
    
    // MARK: - User Actions
    
    fileprivate func moveToPage(page: Int, direction: UIPageViewControllerNavigationDirection) {
        self.pageCount = page
        self.pageControl.currentPage = self.pageCount
        
        let item = self.compassItems[self.pageCount]
        
        self.pageControlViewController.setViewControllers([item.viewController], direction: direction, animated: true, completion: nil)
        self.setupLabel(for: item.scene)

    }

    @IBAction func backAction(_ sender: UIButton) {
        guard self.pageCount > 0 else {
            return
        }
        
        moveToPage(page: self.pageCount - 1, direction: .reverse)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        guard self.pageCount < self.compassItems.count - 1 else {
            return
        }
        
        if let error = self.checkError() {
            
            switch error {
            case .selection:
                self.showAlert(title: "", message: "Please select an item")
            case .text:
                self.showAlert(title: "", message: "Please enter a text")
            }
            return
        }

        moveToPage(page: self.pageCount + 1, direction: .forward)

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

extension CreateCompassViewController: AssessmentViewControllerDelegate {

    func didSelectScene(scene: CompassScene) {
        
        guard let scenePage = (compassItems.index { $0.scene == scene }) else {
            return assertionFailure()
        }
        
        self.moveToPage(page: scenePage, direction: .reverse)
    }

}

