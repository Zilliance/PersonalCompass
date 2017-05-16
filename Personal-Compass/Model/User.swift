//
//  User.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 16-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

final class User: Object {
    
    let compasses =  List<Compass>()

    var incompleteCompasses: [Compass] {
        
        let incomplete = compasses.filter("completed = false")
        
        return Array(incomplete)
    }
    
    
}
