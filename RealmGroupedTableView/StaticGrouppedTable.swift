//
//  ViewController.swift
//  RealmGroupedTableView
//
//  Created by Anish George on 20/10/17.
//  Copyright © 2017 Anish George. All rights reserved.
//

import UIKit
import RealmSwift

var sectionTitles = ["A", "B", "C"]
var objectsBySection = [Results<DemoObject>]()


class Cell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}




class StaticGrouppedTable: UITableViewController {
    var notificationToken: NotificationToken?
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        realm = try! Realm()
        
        // Set realm notification block
        notificationToken = realm.observe { [unowned self] note, realm in
            self.tableView.reloadData()
        }
        for section in sectionTitles {
            let unsortedObjects = realm.objects(DemoObject.self).filter("sectionTitle == '\(section)'")
            let sortedObjects = unsortedObjects.sorted(byKeyPath: "date", ascending: true)
            objectsBySection.append(sortedObjects)
        }
        tableView.reloadData()
    }
    
    // UI
    func setupUI() {
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        
        self.title = "GroupedTableView"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "BG Add", style: .plain, target: self, action: #selector(self.backgroundAdd))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add))
    }
    
    // Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsBySection[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        let object = objectForIndexPath(indexPath: indexPath)
        cell.textLabel?.text = object?.title
        cell.detailTextLabel?.text = object?.date.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(objectForIndexPath(indexPath: indexPath)!)
            }
        }
    }
    
    // Actions
    @objc func backgroundAdd() {
        // Import many items in a background thread
        DispatchQueue.global().async {
            // Get new realm and table since we are in a new thread
            let realm = try! Realm()
            realm.beginWrite()
            for _ in 0..<5 {
                // Add row via dictionary. Order is ignored.
                realm.create(DemoObject.self, value: ["title": self.randomTitle(), "date": NSDate(), "sectionTitle": self.randomSectionTitle()])
            }
            try! realm.commitWrite()
        }
    }
    
    @objc func add() {
        try! realm.write {
            realm.create(DemoObject.self, value: [randomTitle(), NSDate(), randomSectionTitle()])
        }
    }
    
    
    // Helpers
    func objectForIndexPath(indexPath: IndexPath) -> DemoObject? {
        return objectsBySection[indexPath.section][indexPath.row]
    }
    
    func randomTitle() -> String {
        return "Title \(arc4random())"
    }
    
    func randomSectionTitle() -> String {
        return sectionTitles[Int(arc4random()) % sectionTitles.count]
    }
   
}

