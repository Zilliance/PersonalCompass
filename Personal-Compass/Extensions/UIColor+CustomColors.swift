//
//  UIColor+CustomColors.swift
//  Personal Compass
//
//  Created by ricardo hernandez  on 1/23/17.
//  Copyright © 2017 Phil Dow. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let lightBlue = UIColor.color(forRed: 1, green: 188, blue: 213, alpha: 1)
    static let darkBlue = UIColor.color(forRed: 30.0, green: 43.0, blue: 62.0, alpha: 1)
    static let navBar = UIColor.color(forRed: 51.0, green: 74.0, blue: 95.0, alpha: 1)

    static let silverColor = UIColor.color(forRed: 225, green: 225, blue: 228, alpha: 1)

    static let battleshipGrey = UIColor.color(forRed: 117, green: 119, blue: 124, alpha: 1)

    static let paleGrey = UIColor.color(forRed: 237.0, green: 237.0, blue: 239.0, alpha: 1)
    
    class func color(forRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    static let contentBackground = UIColor.color(forRed: 250, green: 250, blue: 250, alpha: 1)

}

// MARK: - Scene Colors

extension UIColor {
    static let stressor = UIColor.color(forRed: 243, green: 135, blue: 32, alpha: 1)
    static let emotion = UIColor.color(forRed: 234, green: 91, blue: 67, alpha: 1)
    static let thought = UIColor.color(forRed: 0, green: 184, blue: 231, alpha: 1)
    static let body = UIColor.color(forRed: 255, green: 184, blue: 55, alpha: 1)
    static let behavior = UIColor.color(forRed: 101, green: 175, blue: 71, alpha: 1)
    static let summary = UIColor.color(forRed: 234, green: 91, blue: 67, alpha: 1)
    static let innerWisdom = UIColor.color(forRed: 98.0, green: 109.0, blue: 218.0, alpha: 1)
    static let feelBetter = UIColor.color(forRed: 98.0, green: 109.0, blue: 218.0, alpha: 1)
}

extension UIColor {

    func lighter(amount : CGFloat = 0.25) -> UIColor {
        return self.hueColorWithBrightnessAmount(amount: 1 + amount)
    }

    func darker(amount : CGFloat = 0.25) -> UIColor {
        return self.hueColorWithBrightnessAmount(amount: 1 - amount)
    }

    private func hueColorWithBrightnessAmount(amount: CGFloat) -> UIColor {
        var hue         : CGFloat = 0
        var saturation  : CGFloat = 0
        var brightness  : CGFloat = 0
        var alpha       : CGFloat = 0       

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor( hue: hue,
                            saturation: saturation,
                            brightness: brightness * amount,
                            alpha: alpha )
        } else {
            return self
        }
    }
}
