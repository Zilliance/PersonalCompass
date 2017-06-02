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

protocol CompassFacetEditor {
    func save()
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
    case innerWisdom1
    case innerWisdom2
    case innerWisdom3
    case innerWisdom4
    case innerWisdom5
    case innerWisdomSummary
    
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
        case .innerWisdom1:
            return .innerWisdom
        case .innerWisdom2:
            return .innerWisdom
        case .innerWisdom3:
            return .innerWisdom
        case .innerWisdom4:
            return .innerWisdom
        case .innerWisdom5:
            return .innerWisdom
        case .innerWisdomSummary:
            return .innerWisdom
        }
    }

    var title: String {
        return self.rawValue.capitalized
    }
    
}

class CreateCompassViewController: UIViewController {
    
    fileprivate struct CompassItem {
        let viewController: UIViewController
        let scene: CompassScene
        
        init(for scene: CompassScene, container: CreateCompassViewController) {
            
            switch scene {
            case .body:
                let viewController = UIStoryboard(name: "StringItems", bundle: nil).instantiateViewController(withIdentifier: "CompassStressViewController") as! CompassStressViewController
                viewController.StringItemType = BodyStress.self
                viewController.currentCompass = container.compass
                viewController.title = "How is the stress of this situation affecting me physically?"
                self.viewController = viewController
                
            case .behavior:
                let viewController = UIStoryboard(name: "StringItems", bundle: nil).instantiateViewController(withIdentifier: "CompassStressViewController") as! CompassStressViewController
                viewController.title = "How are my thoughts about this situation affecting my behavior?"
                viewController.StringItemType = BehaviourStress.self
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
                
            case .innerWisdom1:
                let viewController = UIStoryboard(name: "InnerWisdom", bundle: nil).instantiateViewController(withIdentifier: "1") as! InnerWisdom1ViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController
                
            case .innerWisdom2:
                let viewController = UIStoryboard(name: "InnerWisdom", bundle: nil).instantiateViewController(withIdentifier: "2") as! InnerWisdom2ViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController
                
            case .innerWisdom3:
                let viewController = UIStoryboard(name: "InnerWisdom", bundle: nil).instantiateViewController(withIdentifier: "3") as! InnerWisdom3ViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController
                
            case .innerWisdom4:
                let viewController = UIStoryboard(name: "InnerWisdom", bundle: nil).instantiateViewController(withIdentifier: "4") as! InnerWisdom4ViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController

            case .innerWisdom5:
                let viewController = UIStoryboard(name: "StringItems", bundle: nil).instantiateViewController(withIdentifier: "InnerWisdom5ViewController") as! InnerWisdom5ViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController
                
            case .innerWisdomSummary:
                let viewController = UIStoryboard(name: "InnerWisdom", bundle: nil).instantiateViewController(withIdentifier: "InnerWisdomSummaryViewController") as! InnerWisdomSummaryViewController
                viewController.currentCompass = container.compass
                self.viewController = viewController
            }

            self.scene = scene
        }
    }
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pageControl: FXPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    @IBOutlet weak var returnToSummaryButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var stressorLabel: UILabel!
    
    var compass: Compass = Compass()

    private var currentPageIndex = 0
    
    fileprivate lazy var compassItems: [CompassItem]  = {
        
        var items: [CompassItem] = [
            CompassItem(for: .stressor, container: self),
            CompassItem(for: .emotion, container: self),
            CompassItem(for: .thought, container: self),
            CompassItem(for: .body, container: self),
            CompassItem(for: .behavior, container: self),
            CompassItem(for: .assessment, container: self),
            CompassItem(for: .need, container: self),
            CompassItem(for: .innerWisdom1, container: self),
            CompassItem(for: .innerWisdom2, container: self),
            CompassItem(for: .innerWisdom3, container: self),
            CompassItem(for: .innerWisdom4, container: self),
            CompassItem(for: .innerWisdom5, container: self),
            CompassItem(for: .innerWisdomSummary, container: self),
        ]
        
        return items
        
    }()
    
    private lazy var pageControlViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
             self.currentPageIndex = Int(self.compass.lastEditedFacet.pageIndex)
        controller.setViewControllers([self.compassItems[self.currentPageIndex].viewController], direction: .forward, animated: true, completion: nil)
        self.pageControl.currentPage = self.currentPageIndex
        self.setupLabel(for: self.compassItems[self.currentPageIndex].scene)
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
        self.pageControl.dotSpacing = 20
        self.pageControl.backgroundColor = .clear
        self.pageControl.selectedDotImage = #imageLiteral(resourceName: "pageview-dot-on")
        self.pageControl.dotImage = #imageLiteral(resourceName: "pageview-dot-off")
        
        
        
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
        
        if scene == .stressor {
            self.backButton.alpha = 0
        }
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.topLabel.layer.backgroundColor = scene.color.cgColor
            switch scene {
            case .stressor:
                self.topLabel.text = scene.rawValue.capitalized
                self.backButton.alpha = 0
            default:
                self.stressorLabel.alpha = 1
            }

        }) { _ in
        
            switch scene {
            case .innerWisdom1, .innerWisdom2, .innerWisdom3, .innerWisdom4, .innerWisdom5:
                self.topLabel.text = "Inner Wisdom"
            default:
                self.topLabel.text = scene.rawValue.capitalized
                self.stressorLabel.text = self.compass.stressor?.uppercased()
            }
            
        }
        
    }
    
    fileprivate func toggleSummaryButton() {
        
        let isShowing = self.returnToSummaryButton.alpha == 1 ? true : false
        
        UIView.animate(withDuration: 0.3) { 
            self.returnToSummaryButton.alpha = isShowing ?  0 : 1
            self.nextButton.alpha = isShowing ? 1 : 0
            self.backButton.alpha = isShowing ? 1 : 0
            
        }
    
    }
    
    private func checkError() -> CompassError? {
        guard let vc = self.compassItems[self.currentPageIndex].viewController as? CompassValidation else {
            return nil
        }
        return vc.error
    }
    
    
    // MARK: - User Actions
    
    fileprivate func moveToPage(page: Int, direction: UIPageViewControllerNavigationDirection) {
        
        if let currentItem = self.compassItems[self.currentPageIndex].viewController as? CompassFacetEditor {
            currentItem.save()
        }
        
        self.currentPageIndex = page
        self.pageControl.currentPage = self.currentPageIndex
        
        let item = self.compassItems[self.currentPageIndex]
        
        self.pageControlViewController.setViewControllers([item.viewController], direction: direction, animated: true, completion: nil)
        self.setupLabel(for: item.scene)

    }

    @IBAction func backAction(_ sender: UIButton) {
        guard self.currentPageIndex > 0 else {
            return
        }
        
        moveToPage(page: self.currentPageIndex - 1, direction: .reverse)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        guard self.currentPageIndex < self.compassItems.count - 1 else {
            return
        }
        
        if self.currentPageIndex == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.backButton.alpha = 1
            })
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

        self.moveToPage(page: self.currentPageIndex + 1, direction: .forward)

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        let update = Database.shared.user.compasses.filter { $0.id == self.compass.id }.count > 0
        
        var alertController: UIAlertController
        
        if (update) {
            
            alertController = UIAlertController(title: nil, message: "Cancelling will discard changes to your compass. Are you sure you want to cancel?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Don't Cancel", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(UIAlertAction(title: "Discard Changes", style: .destructive) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            })

        }
        else {
            alertController = UIAlertController(title: nil, message: "Cancelling will discard your new compass. Are you sure you want to cancel?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Don't Cancel", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(UIAlertAction(title: "Discard New Compass", style: .destructive) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            })
            
        }
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if let currentItem = self.compassItems[self.currentPageIndex].viewController as? CompassFacetEditor {
            currentItem.save()
        }

        let update = Database.shared.user.compasses.filter { $0.id == self.compass.id }.count > 0
        
        if (update) {
            Database.shared.add(realmObject: self.compass, update: true)
        }
        else {
            Database.shared.save {
                Database.shared.user.compasses.append(self.compass)
            }
        }
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func returnToSummaryAction(_ sender: Any) {
        self.toggleSummaryButton()
        self.moveToPage(page: Compass.Facet.assessment.pageIndex, direction: .forward)
    }
}

extension CreateCompassViewController: AssessmentViewControllerDelegate {

    func didSelectScene(scene: CompassScene) {
        
        guard let scenePage = (compassItems.index { $0.scene == scene }) else {
            return assertionFailure()
        }
        self.toggleSummaryButton()
        self.moveToPage(page: scenePage, direction: .reverse)
    }

}

