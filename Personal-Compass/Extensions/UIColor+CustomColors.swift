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

    
    class func color(forRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
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
