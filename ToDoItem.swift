//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Richard Jo on 7/8/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import Foundation
import RealmSwift

//LocalDatabaseManager - manages/creates Realm instances for local data persistence
class LocalDatabaseManager {
    static func getRealmContext() -> Realm? {
        //Returns a Realm instance - if fails, returns nil
        do {
            let realm = try Realm()
            return realm
        } catch {
            return nil
        }
    }
}

//Task class - stores individual task data (name, details, creation date, etc)
class Task:Object {
    //Task name (i.e. run a mile)
    @objc dynamic var name = ""
    //Task details (i.e. at Hibbard Park)
    @objc dynamic var detail = ""
    //Task creation date (i.e. 1/1/2020)
    @objc dynamic var dateCreated = NSDate()
    //Task due date (i.e. 1/2/2020)
    @objc dynamic var dateDue = NSDate()
    @objc dynamic var isCompleted = false
    
    convenience init(name:String, detail:String, dateDue:NSDate) {
        self.init()
        self.name = name
        self.detail = detail
        self.dateCreated = NSDate()
        self.dateDue = dateDue
        self.isCompleted = false
    }
}
