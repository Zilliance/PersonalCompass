//
//  Analytics+PersonalCompass.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 10/4/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import ZillianceShared

class PersonalCompassAnalytics: ZillianceAnalytics {
    
    enum PersonalCompassEvent: String, AnalyticEvent {
        
        
        // new compass creation events
        case newCompass
        case compassCompleted
        case compassResumed
        
        // audio
        
        case didPlayMeditationAudio
        case didStopMeditationAudio
        
        // sharing
        
        case didShareCompass
        
        
    }
    
}
