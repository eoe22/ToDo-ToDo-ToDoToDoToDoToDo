//
//  currentToDoViewController.swift
//  TODO app
//
//  Created by C2QJG01SDRJD on 12/8/18.
//  Copyright © 2018 C2QJG01SDRJD. All rights reserved.
//

import UIKit

class currentToDoViewController: UIViewController {
    
    let reuseIdentifier = "cell"
    
    @IBOutlet var tableView: UITableView!

    //data
    var todoData = ["One", "Two", "Three"]
    
    var todos = [Todo]()
    var numOfShownToDo: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load data to tableView
        self.tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: reuseIdentifier)
    }
    
    func loadArchived() {
        DispatchQueue.global().async { [unowned self] in
            self.todos = Todo.loadSavedToDo()
            DispatchQueue.main.async {
                [unowned self] in self.tableView.reloadData()
            }
        }
    }
    
    func loadToDos() {
        DispatchQueue.global().async {
            let filePath = Bundle.main.path(forResource: "todos", ofType: "json")
            let url = URL.init(fileURLWithPath: filePath!)
            
            do {
                let todoData = try Data.init(contentsOf: url)
                let todoJSON = try JSONSerialization.jsonObject(with: todoData, options: .mutableLeaves) as! [[String:Any]]
                
                for x in todoJSON {
                    var todo: String? = nil
                    var descriptionData: String? = nil
                    var dateTime: Date? = nil
                    var completed: Bool = false
                    
                    todo = x["todo"] as! String
                    descriptionData = x["descriptionData"] as! String
                    dateTime = x["dateTime"] as! Date
                    
                    let newToDo = Todo(todo: todo, descriptionData: descriptionData, dateTime: dateTime, completed: completed)
                    self.todos.append(newToDo)
                }
            }
            catch {
                print("\(error)")
                return
            }
            DispatchQueue.main.async {
                [unowned self] in self.tableView.reloadData()
            }
        }
    }
    
}


extension currentToDoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //1 section only
        return 1
        
        //multiple sections
        //return toDos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return all todos
        return todoData.count
        
        //return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath)
        
        cell.textLabel?.text = todoData[indexPath.row]
        //cell.textLabel?.text = toDos[indexPath.section]
        
        cell.backgroundColor = UIColor.blue
        
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}
