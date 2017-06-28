//
//  UIViewController+TopMost.swift
//  Personal-Compass
//
//  Created by Philip Dow on 6/28/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func topmost() -> UIViewController {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topmost()
        }
        // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if let viewController = subViewController as? UIViewController {
                        return viewController.topmost()
                    }
                }
            }
            return self
        }
    }
}
