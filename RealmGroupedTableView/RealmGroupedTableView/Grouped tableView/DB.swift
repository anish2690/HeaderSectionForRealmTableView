//
//  DB.swift
//  RealmGroupedTableView
//
//  Created by Anish George on 20/10/17.
//  Copyright © 2017 Anish George. All rights reserved.
//


import UIKit
import RealmSwift

class DemoObject: Object {
    @objc dynamic var title = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var sectionTitle = ""
}

class Cell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}
