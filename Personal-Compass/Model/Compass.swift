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
        case stressor
        case emotion
        case thought
        case body
        case behaviour
        case innerWisdom
        case need
        
        var pageIndex: Int {
            switch self {
            case .unknown:
                return 0
            case .stressor:
                return 1
            case .emotion:
                return 2
            case .thought:
                return 3
            case .body:
                return 4
            case .behaviour:
                return 4
            default:
                return 0

            }
        }
        
    }
    
    dynamic var lastEditedFacet: Facet = .unknown
    
    let bodyStressElements = List<BodyStress>()

    let behaviourStressElements = List<BehaviourStress>()
    
    dynamic var emotion: Emotion?
    
    dynamic var stressor: String?
    
    dynamic var need: String?
    
    dynamic var thoughtAboutEmotion: String?
    
    dynamic var innerWisdom: String?
    
    dynamic var completed: Bool = false
    
    dynamic var dateCreated: Date = Date()
    
}

extension Compass {
    
    static func createNewCompass() -> Compass {
        let newCompass = Compass()
        Database.shared.add(realmObject: newCompass)
        return newCompass
    }
    
}
