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
        case innerWisdom5
        case innerWisdomSchedule
        
        var pageIndex: Int {

            return Int(self.rawValue)
        }
        
    }
    
    dynamic var lastEditedFacet: Facet = .stressor //this is the first facet to edit
    
    let bodyStressElements = List<BodyStress>()

    let behaviourStressElements = List<BehaviourStress>()
    
    let positiveActivities = List<PositiveActivity>()
    
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



