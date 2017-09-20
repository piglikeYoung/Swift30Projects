//
//  ViewController.swift
//  HitList
//
//  Created by pike young on 2017/9/20.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var people: [NSManagedObject] = []
    
    // MARK - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationTitle()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        self.fetchCoreData(managedContext)
    }
    
    func setupNavigationTitle() {
        self.title = "The List"
    }
    
    func fetchCoreData(_ managerContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            let results = try managerContext.fetch(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // remove the deleted item from the model
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managerContext = appDelegate.managedObjectContext
            managerContext.delete(people[indexPath.row] as NSManagedObject)
            
            do {
                try managerContext.save()
                people.remove(at: indexPath.row)
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }
    
    // MARK - IBActions
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "save", style: .default) { (action) in
            let textField = alert.textFields?.first
            self.saveName(textField!.text!)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        
        alert.addTextField { (textField) in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - CoreData func
    func saveName(_ name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managerContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managerContext)
        let person = NSManagedObject(entity: entity!, insertInto: managerContext)
        
        person.setValue(name, forKey: "name")
        
        do {
            try managerContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}

