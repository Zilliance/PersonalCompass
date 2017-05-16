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
    
    /// You may access the realm object directly to query for objects or use the
    /// convenience methods provided below
    
    private(set) var realm: Realm!
    
    fileprivate(set) var user: User!
    
    private(set) var bodyStressStored: Results<BodyStress>!

    private(set) var physicalStressStored: Results<PhysicalStress>!
    
    init() {
        do {
            
            // Inside your application(application:didFinishLaunchingWithOptions:)
            
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
            
            physicalStressStored = self.realm.objects(PhysicalStress.self).sorted(byKeyPath: "title")

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
    
    
    private func bootstrap() {
        //we'll preload the body stress and physical stress elements here
    }

}


//all bootstrap methods
extension Database {
    
    private func bootstrapUser() {
        guard self.realm.objects(User.self).count == 0 else {
            return
        }
        
        let user = User()

        add(realmObject: user)
        
        self.user = user
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
