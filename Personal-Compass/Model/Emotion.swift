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
    
//    @objc enum Level: Int32 {
//        case one
//        case two
//        case three
//        case four
//        case five
//        case six
//        case seven
//        case eight
//        case nine
//        case ten
//        
//        static var levelsCount: Int {
//            return 10
//        }
//
//    }
    
    dynamic var level: Int = 0
    
    dynamic var shortTitle: String = ""

    dynamic var longTitle: String = ""
    
    var icon: UIImage? {
        let iconName = "emotion-icon-\(self.level)"
        return UIImage(named: iconName)
    }

}