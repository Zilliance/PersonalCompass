//
//  Database.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 16-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

class StressItem: Object {

    dynamic var title: String?
    dynamic var order: Int = 0
    
    class func createNew(title: String) -> Self {
        
        let newItem = self.init()
        newItem.order = -1
        newItem.title = title
        
        Database.shared.add(realmObject: newItem)
        
        return newItem
    }

}

class Database {
    static let shared = Database()
    
    private(set) var realm: Realm!
    
    fileprivate(set) var user: User!
    
    private(set) var bodyStressStored: Results<BodyStress>!

    private(set) var behaviourStressStored: Results<BehaviourStress>!
    
    init() {
        do {
                        
            let config = Realm.Configuration(
                schemaVersion: 2,
                
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
            
            bodyStressStored = self.realm.objects(BodyStress.self).sorted(byKeyPath: "order")
            
            behaviourStressStored = self.realm.objects(BehaviourStress.self).sorted(byKeyPath: "order")

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
    
    func allEmotions() -> Results<Emotion>
    {
        return self.realm.objects(Emotion.self)
    }

}


//all bootstrap methods
extension Database {
    
    fileprivate func bootstrap() {
        self.bootstrapEmotions()
        self.bootstrapBodyStress()
        self.bootstrapBehaviourStress()
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
    
    typealias StressData = [String]
    
    fileprivate func parseStressData(fileName: String, itemType: StressItem.Type) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "plist"), let data = NSArray(contentsOfFile: path) as? StressData {
            
            try! realm.write({
                
                data.enumerated().forEach({ offset, stressItem  in
                    //newItemLoaded(offset, stressItem)
                    
                    let newStressItem = itemType.init()
                    newStressItem.title = stressItem
                    newStressItem.order = offset
                    
                    realm.add(newStressItem)
                    
                })
            })
        }
    }
    
    fileprivate func bootstrapBodyStress() {
        
        parseStressData(fileName: "PreloadedBodyStress", itemType: BodyStress.self)
        
    }
    
    fileprivate func bootstrapBehaviourStress() {

        parseStressData(fileName: "PreloadedBehaviourStress", itemType: BehaviourStress.self)

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
