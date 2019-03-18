//
//  ToDo.swift
//  TODO app
//
//  Created by C2QJG01SDRJD on 12/9/18.
//  Copyright © 2018 C2QJG01SDRJD. All rights reserved.
//

import Foundation

class Todo: NSObject, NSCoding {
    // MARK: Persistence Directory
    static var FileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let FilePath: URL = Todo.FileDirectory.appendingPathComponent("savedToDos")
    
    // MARK: Properties
    var todo: String
    var descriptionData: String
    var dateTime: Date
    var completed: Bool = false
    
    // MARK: NSCoding
    struct CodingKeys {
        static let todo = "todo"
        static let descriptionData = "descriptionData"
        static let dateTime = "dateTime"
        static let completed = "completed"
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(self.todo, forKey: CodingKeys.todo)
        aCoder.encode(self.descriptionData, forKey: CodingKeys.descriptionData)
        aCoder.encode(self.dateTime, forKey: CodingKeys.dateTime)
        aCoder.encode(self.completed, forKey: CodingKeys.completed)
    }
    
    required init?(coder aDecoder: NSCoder){
        self.todo = aDecoder.decodeObject(forKey: CodingKeys.todo) as! String
        self.descriptionData = aDecoder.decodeObject(forKey: CodingKeys.descriptionData) as! String
        self.dateTime = aDecoder.decodeObject(forKey: CodingKeys.dateTime) as! Date
        self.completed = aDecoder.decodeBool(forKey: CodingKeys.completed)
    }
}

// MARK: Persistence Methods, NSKeyedArchiver
extension Todo {
    static func saveToDo(_ todos: [Todo]){
        let todoData = NSKeyedArchiver.archivedData(withRootObject: todos)
        
        do {
            try todoData.write(to: Todo.FilePath)
        }
        catch {
            print("Error in writing data")
        }
    }
    
    static func loadSavedToDo() -> [Todo] {
        guard let savedData = NSData(contentsOf: Todo.FilePath)
            else {
            print("No saved data")
                return []
        }
        
        do {
            let todos = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as! [Todo]
            return todos
        }
        catch {
            print("Error whle unarchiving: \(error)")
            return []
        }
    }
}



