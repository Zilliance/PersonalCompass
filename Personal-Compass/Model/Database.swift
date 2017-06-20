//
//  Database.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 16-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
import RealmSwift

class StringItem: Object {

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
    
    private(set) var positiveActivitiesStored: Results<PositiveActivity>!

    
    init() {
        do {
                        
            let config = Realm.Configuration(
                schemaVersion: 10,
                
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
            
            let sortProperties = [SortDescriptor(keyPath: "order", ascending: true), SortDescriptor(keyPath: "title", ascending: true)]
            
            bodyStressStored = self.realm.objects(BodyStress.self).sorted(by: sortProperties)
            
            behaviourStressStored = self.realm.objects(BehaviourStress.self).sorted(by: sortProperties)
            
            positiveActivitiesStored = self.realm.objects(PositiveActivity.self).sorted(by: sortProperties)

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
        self.bootstrapPositiveActivities()
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
                    guard let title = emotion["title"] else {
                        return assertionFailure()
                    }
                    
                    let newEmotion = Emotion()
                    newEmotion.level = offset
                    newEmotion.title = title
                    
                    realm.add(newEmotion)
                    
                })
            })
        }
    }
    
    typealias StringData = [String]
    
    fileprivate func parseStringData(fileName: String, itemType: StringItem.Type) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "plist"), let data = NSArray(contentsOfFile: path) as? StringData {
            
            try! realm.write({
                
                data.enumerated().forEach({ offset, StringItem  in
                    //newItemLoaded(offset, StringItem)
                    
                    let newStringItem = itemType.init()
                    newStringItem.title = StringItem
                    newStringItem.order = offset
                    
                    realm.add(newStringItem)
                    
                })
            })
        }
    }
    
    fileprivate func bootstrapBodyStress() {
        
        parseStringData(fileName: "PreloadedBodyStress", itemType: BodyStress.self)
        
    }
    
    fileprivate func bootstrapBehaviourStress() {

        parseStringData(fileName: "PreloadedBehaviourStress", itemType: BehaviourStress.self)

    }
    
    fileprivate func bootstrapPositiveActivities() {
        
        parseStringData(fileName: "PreloadedPositiveActivities", itemType: PositiveActivity.self)
        
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
    
    func delete(_ object: Object) {
        do {
            try realm.write {
                 realm.delete(object)
            }
        }
        catch let error {
            print(error)
        }
    }
    
    func add(realmObject: Object, update: Bool = false) {
        do {
            try realm.write({
                realm.add(realmObject, update: update)
            })
        }
        catch let error {
            print(error)
        }
    }
    
}
