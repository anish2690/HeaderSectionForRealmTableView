//
//  DynamicTableViewSection.swift
//  RealmGroupedTableView
//
//  Created by Anish George on 22/10/17.
//  Copyright © 2017 Anish George. All rights reserved.
//

import UIKit
import RealmSwift

class DynamicTableViewSection: UITableViewController {
    
    let items = try! Realm().objects(Dog.self).sorted(byKeyPath: "race", ascending: true)
    var sectionNames: [String] {
        return Set(items.value(forKeyPath: "race") as! [String]).sorted()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("sectionNames \(sectionNames)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let realm = try! Realm()
        if realm.objects(Dog.self).isEmpty {
            try! realm.write {
                realm.add(Dog(name: "Bailey", race: "Golden Retrievers", dogID: "0"))
                realm.add(Dog(name: "Bella", race: "German Shepherds", dogID: "1"))
                realm.add(Dog(name: "Max", race: "Bulldogs", dogID: "2"))
                realm.add(Dog(name: "Lucy", race: "Yorkshire Terriers", dogID: "3"))
                realm.add(Dog(name: "Charlie", race: "Bulldogs", dogID: "4"))
                realm.add(Dog(name: "Molly", race: "German Shepherds", dogID: "5"))
                realm.add(Dog(name: "Buddy", race: "German Shepherds", dogID: "6"))
                realm.add(Dog(name: "Daisy", race: "Siberian Huskies", dogID: "7"))
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return sectionNames.count
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.filter("race == %@", sectionNames[section]).count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        print("IndexPath \(indexPath)")
        
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
                cell.textLabel?.text = items.filter("race == %@", sectionNames[indexPath.section])[indexPath.row].name
                return cell
    }
}
