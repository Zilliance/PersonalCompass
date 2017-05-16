//
//  Compass.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 16-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

final class Compass: Object {
    
    @objc enum Characteristic: Int32 {
        case notStarted
        case phase1
    }
    
    dynamic var lastEditedCharacteristic: Characteristic = .notStarted
    
    let bodyStressElements = List<BodyStress>()

    let physicalStressElements = List<PhysicalStress>()
    
    dynamic var emotion: Emotion?
    
    dynamic var thoughtAboutEmotion: String?
    
    dynamic var innerWisdom: String?
    
    dynamic var completed: Bool = false
    
}

extension Compass {
    
    static func createNewCompass() -> Compass {
        let newCompass = Compass()
        Database.shared.add(realmObject: newCompass)
        return newCompass
    }
    
}
