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
    
    @objc enum Facet: Int32 {
        case unknown
        case emotion
        case thought
        case body
        case behaviour
        case innerWisdom
    }
    
    dynamic var lastEditedFacet: Facet = .unknown
    
    let bodyStressElements = List<BodyStress>()

    let behaviourStressElements = List<BehaviourStress>()
    
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
