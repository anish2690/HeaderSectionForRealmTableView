//
//  RealmDb.swift
//  RealmGroupedTableView
//
//  Created by Anish George on 22/10/17.
//  Copyright © 2017 Anish George. All rights reserved.
//


import UIKit
import RealmSwift

class DemoObject: Object {
    @objc dynamic var title = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var sectionTitle = ""
}
class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var race = ""
    @objc dynamic var age = 0
    @objc dynamic var owner = ""
    @objc dynamic var dogID = ""
    
    
    override static func primaryKey() -> String? {
        return "dogID"
    }
    
    convenience init(name: String, race: String, dogID: String) {
        self.init()
        self.name = name
        self.race = race
        self.dogID = dogID
        
        
    }
}
    class Message: Object {
        @objc dynamic var msg_id = ""
        @objc dynamic var message = ""
        @objc dynamic var date = ""
        
        override static func primaryKey() -> String? {
            return "msg_id"
        }
        
        convenience init(msg_id: String, message: String, date: String) {
            self.init()
            self.msg_id = msg_id
            self.message = message
            self.date = date
            
        }
}

