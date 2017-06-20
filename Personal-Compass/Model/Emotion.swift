//
//  Emotion.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 16-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

final class Emotion: Object {
    
    dynamic var level: Int = 0

    dynamic var longTitle: String = ""
    
    var icon: UIImage? {
        let iconName = "emotion-icon-\(self.level)"
        return UIImage(named: iconName)
    }
    
    var color: UIColor {
        
        switch self.level {
        case 0:
            return UIColor.color(forRed: 220, green: 101, blue: 69, alpha: 1)
        case 1:
            return UIColor.color(forRed: 227, green: 146, blue: 55, alpha: 1)
        case 2:
            return UIColor.color(forRed: 175, green: 173, blue: 68, alpha: 1)
        case 3:
            return UIColor.color(forRed: 126, green: 176, blue: 65, alpha: 1)
        case 4:
            return UIColor.color(forRed: 112, green: 180, blue: 74, alpha: 1)
        case 5:
            return UIColor.color(forRed: 72, green: 181, blue: 73, alpha: 1)
        case 6:
            return UIColor.color(forRed: 58, green: 181, blue: 122, alpha: 1)
        case 7:
            return UIColor.color(forRed: 42, green: 181, blue: 161, alpha: 1)
        case 8:
            return UIColor.color(forRed: 31, green: 147, blue: 179, alpha: 1)
        case 9:
            return UIColor.color(forRed: 76, green: 137, blue: 199, alpha: 1)
        case 10:
            return UIColor.color(forRed: 108, green: 114, blue: 182, alpha: 1)
        default:
            return .black
        }
    }

}
