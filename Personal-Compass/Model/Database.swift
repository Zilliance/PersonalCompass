//
//  Database.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 16-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    static let shared = Database()
    
    private(set) var realm: Realm!
    
    fileprivate(set) var user: User!
    
    private(set) var bodyStressStored: Results<BodyStress>!

    private(set) var behaviorStressStored: Results<BehaviorStress>!
    
    init() {
        do {
                        
            let config = Realm.Configuration(
                schemaVersion: 0,
                
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                        // Nothing to do!
                        // Realm will automatically detect new properties and removed properties
                        // And will update the schema on disk automatically
                    }
            })
            
            // Tell Realm to use this new configuration object for the default Realm
            Realm.Configuration.defaultConfiguration = config
            
            self.realm = try Realm()
            
            bodyStressStored = self.realm.objects(BodyStress.self).sorted(byKeyPath: "title")
            
            behaviorStressStored = self.realm.objects(BehaviorStress.self).sorted(byKeyPath: "title")

            if let user = self.realm.objects(User.self).first
            {
                self.user = user
            }
            else
            {
                //first time launch, let's prepare the DB
                self.bootstrap()
            }
            
            
        } catch {
            print("realm initialization failed, aborting")
        }
    }
    
    func appStarted() {
        //nothing to do here, all initialization is being done on the init.
    }

}


//all bootstrap methods
extension Database {
    
    fileprivate func bootstrap() {
        //we'll preload the body stress and physical stress elements here
        self.bootstrapEmotions()
        self.bootstrapUser()
    }
    
    fileprivate func bootstrapUser() {
        guard self.realm.objects(User.self).count == 0 else {
            return
        }
        
        let user = User()

        add(realmObject: user)
        
        self.user = user
    }
    
    typealias PreloadedEmotionData = [[String: String]]
    fileprivate func bootstrapEmotions() {
        
        let emotionsPreloaded = realm.objects(Emotion.self)
        print(emotionsPreloaded)
        
        if let path = Bundle.main.path(forResource: "PreloadedEmotions", ofType: "plist"), let emotions = NSArray(contentsOfFile: path) as? PreloadedEmotionData {
        
            try! realm.write({
                emotions.enumerated().forEach({ offset, emotion in
                    guard let longTitle = emotion["longTitle"], let shortTitle = emotion["shortTitle"] else {
                        return assertionFailure()
                    }
                    
                    let newEmotion = Emotion()
                    newEmotion.level = offset
                    newEmotion.longTitle = longTitle
                    newEmotion.shortTitle = shortTitle
                    
                    realm.add(newEmotion)
                    
                })
            })

        }
    }
    
    
}

//realm storage methods
extension Database {
    
    func save(storeLogic: () -> ()) {
        do {
            try realm.write(storeLogic)
        }
        catch let error {
            print(error)
        }
    }
    
    func add(realmObject: Object) {
        do {
            try realm.write({
                realm.add(realmObject)
            })
        }
        catch let error {
            print(error)
        }
    }
    
}
