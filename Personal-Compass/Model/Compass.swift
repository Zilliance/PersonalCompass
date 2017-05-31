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
        case assessment
        case need
        case innerWisdom1
        case innerWisdom2
        case innerWisdom3
        case innerWisdom4
        
        var pageIndex: Int {
            switch self {
            case .unknown:
                return 0
            case .stressor:
                return 0
            case .emotion:
                return 1
            case .thought:
                return 2
            case .body:
                return 3
            case .behaviour:
                return 4
            case .assessment:
                return 5
            case .need:
                return 6
            case .innerWisdom1:
                return 7
            case .innerWisdom2:
                return 8
            case .innerWisdom3:
                return 9
            case .innerWisdom4:
                return 10

            }
        }
        
    }
    
    dynamic var lastEditedFacet: Facet = .unknown
    
    let bodyStressElements = List<BodyStress>()

    let behaviourStressElements = List<BehaviourStress>()
    
    dynamic var emotion: Emotion?
    
    dynamic var needMetEmotion: Emotion?
    
    dynamic var stressor: String?
    
    dynamic var need: String?
    
    dynamic var editedNeed: String?
    
    dynamic var concreteStep: String?
    
    dynamic var thoughtAboutEmotion: String?
    
    dynamic var innerWisdom: String?
    
    dynamic var completed: Bool = false
    
    dynamic var dateCreated: Date = Date()
    
    dynamic var id: String = UUID().uuidString
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}



