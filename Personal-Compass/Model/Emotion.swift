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
    
    dynamic var shortTitle: String = ""

    dynamic var longTitle: String = ""
    
    var icon: UIImage? {
        let iconName = "emotion-icon-\(self.level)"
        return UIImage(named: iconName)
    }
    
    var color: UIColor {
        return UIColor.green // TODO
    }

}
