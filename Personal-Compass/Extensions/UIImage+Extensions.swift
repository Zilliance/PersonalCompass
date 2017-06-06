//
//  UIImage+Extensions.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 6/6/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation

import UIKit

extension UIImage {
    
    /// Tints an image
    func tinted(color: UIColor) -> UIImage {
        let image = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage ?? self
    }
}
