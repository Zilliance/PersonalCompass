//
//  Compass.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 16-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift


//**Objects**
//    
//    - User
//    - Compass
//    - Emotion
//    - BodyStress
//    - BehaviorStress
//
//Compass object will be the primary model object for the app. A user will have a variable number of compasses, some of which will be completed and some uncompleted at any given time.
//
//May want a User object so that a user has many compasses.
//
//PhysicalStress and PsychologicalStress objects are selected from a list and added to a Compass. A compass will have an array of each of these kinds of objects.
//
//**Compass Properties**
//
//- Emotion (choose 1)
//- Number of text fields
//- [BodyStress]
//- [BehaviorStress]


final class Compass: Object {
    
    @objc enum Characteristic: Int32 {
        case notStarted
        case phase1
    }
    
    dynamic var lastEditedCharacteristic: Characteristic = .notStarted
    
    var bodyStressElements = List<BodyStress>()

    var physicalStressElements = List<PhysicalStress>()
    
    dynamic var emotion: Emotion?
    
    dynamic var thoughtAboutEmotion: String?
    
    dynamic var innerWisdom: String?
    
}
