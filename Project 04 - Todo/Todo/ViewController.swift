//
//  ViewController.swift
//  Todo
//
//  Created by pike young on 2017/7/27.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

var todos: [ToDoItem] = []

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        todos = [ToDoItem(id: "1", image: "child-selected", title: "Go to Disney", date: dateFromString("2014-10-20")!),
                 ToDoItem(id: "2", image: "shopping-cart-selected", title: "Cicso Shopping", date: dateFromString("2014-10-28")!),
                 ToDoItem(id: "3", image: "phone-selected", title: "Phone to Jobs", date: dateFromString("2014-10-30")!),
                 ToDoItem(id: "4", image: "travel-selected", title: "Plan to Europe", date: dateFromString("2014-10-31")!)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK - helper func
    func setMessageLabel(_ messageLabel: UILabel, frame: CGRect, text: String, textColor: UIColor, numberOfLines: Int, textAlignment: NSTextAlignment, font: UIFont) {
        messageLabel.frame = frame
        messageLabel.text = text
        messageLabel.textColor = textColor
        messageLabel.numberOfLines = numberOfLines
        messageLabel.textAlignment = textAlignment
        messageLabel.font = font
        messageLabel.sizeToFit()
    }
    
    func setCellWithTodoItem(_ cell: UITableViewCell, todo: ToDoItem) {
        let imageView: UIImageView = cell.viewWithTag(11) as! UIImageView
        let titleLabel: UILabel = cell.viewWithTag(12) as! UILabel
        let dateLabel: UILabel = cell.viewWithTag(13) as! UILabel
        
        imageView.image = UIImage(named: todo.image)
        titleLabel.text = todo.title
        dateLabel.text = stringFromDate(todo.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTodo" {
            let vc = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            if let indexPath = indexPath {
                vc.todo = todos[indexPath.row]
            }
        }
    }
    
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todos.count != 0 {
            return todos.count
        } else {
            let messageLabel: UILabel = UILabel()
            
            setMessageLabel(messageLabel, frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), text: "No data is currently available.", textColor: UIColor.black, numberOfLines: 0, textAlignment: NSTextAlignment.center, font: UIFont(name:"Palatino-Italic", size: 20)!)
            
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "todoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        setCellWithTodoItem(cell, todo: todos[(indexPath as NSIndexPath).row])
        
        return cell
    }
}

extension ViewController {
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    // Delete the cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    // Move the cell
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.isEditing
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos.remove(at: sourceIndexPath.row)
        todos.insert(todo, at: destinationIndexPath.row)
    }
}

