//
//  Analytics.swift
//  Personal-Compass
//
//  Created by ricardo hernandez  on 10/4/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import Fabric
import Answers
import Amplitude_iOS
import ZillianceShared

final class Analytics: AnalyticsService {
    
    static let shared = Analytics()
    
    func initialize() {
        
        //Fabric
        Fabric.with([Answers.self])
        
        //Amplitude
        Amplitude.instance().initializeApiKey("06340c361683be51394dce61fc1e16")
        
        ZillianceAnalytics.initialize(projectName: "Personal.Compass.", analyticsService: self)
        
    }
    
    func send(event: AnalyticEvent) {
        
        Answers.logCustomEvent(withName: event.name, customAttributes: event.data)
        
        Amplitude.instance().logEvent(event.name, withEventProperties: event.data)
        
    }
    
}
