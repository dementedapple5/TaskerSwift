//
//  TaskManager.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 19/03/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

import Foundation

class TasksManager: SQLiteDAO {
    
    var tasks: [Task] = [Task]()
    
    func insert(_ database: FMDatabase, _ newRecord: AnyObject) -> Bool {
        var result = false;
        if database.open() {
            let insertSQL = "INSERT INTO TASK (title, body, creation_date, expiration_date, difficulty, priority, completed, completition_date) VALUES (?,?,?,?,?,?,0,null)"
            
            let task = newRecord as! Task
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let creationDateStr = formatter.string(from: task.creationDate)
            let expDateStr = formatter.string(from: task.expirationDate)
            
            let data:Array = ["\((newRecord as! Task).title)", "\((newRecord as! Task).body)",
                "\(creationDateStr)", "\(expDateStr)",
                "\((newRecord as! Task).difficulty)", "\((newRecord as! Task).priority)"]
            
            result = database.executeUpdate(insertSQL, withArgumentsIn: data)
            database.close()
        }else {
            print("Error: \(database.lastErrorMessage())")
        }
        return result
    }
    
    func delete(_ database: FMDatabase, _ recordToDelete: AnyObject) -> Bool {
        var result = false;
        if database.open() {
            let deleteSQL = "DELETE FROM TASK WHERE id=?"
            let data: Array=["\(recordToDelete as! Int)"]
            result = database.executeUpdate(deleteSQL, withArgumentsIn: data)
            database.close()
        }else {
            print("Error: \(database.lastErrorMessage())")
        }
        return result
    }
    
    func readRecords(_ database: FMDatabase,_ state: Int) -> Array<AnyObject> {
        var tasks: Array<Task> = Array()
        if database.open() {
            let querySQL = "SELECT * FROM TASK WHERE completed = \(state) ORDER BY priority DESC, expiration_date "
            let anyArray: Array<Any> = Array()
            
            if let results:FMResultSet = database.executeQuery(querySQL, withArgumentsIn: anyArray) {
                
                while (results.next()){
                    let id = results.int(forColumn: "id")
                    let title = results.string(forColumn: "title")
                    let body = results.string(forColumn: "body")
                    let creationDateStr = results.string(forColumn: "creation_date")
                    let expirationDateStr = results.string(forColumn: "expiration_date")
                    let difficulty = results.int(forColumn: "difficulty")
                    let priority = results.int(forColumn: "priority")
                    let completedInt = results.int(forColumn: "completed")
                    let completitionDateStr = results.string(forColumn: "completition_date")
                    
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let creationDate = formatter.date(from: creationDateStr!)
                    let expirationDate = formatter.date(from: expirationDateStr!)
                    if (completedInt == 1) {
                        let completitionDate = formatter.date(from: completitionDateStr!)
                        let task = Task(Int(id), title!, body!, expirationDate!, Int(difficulty), Int(priority), creationDate!, true, completitionDate!)
                        tasks.append(task)
                    }else {
                        let task = Task(Int(id), title!, body!, expirationDate!, Int(difficulty), Int(priority), creationDate!, false, nil)
                        tasks.append(task)
                    }
                }
                results.close()
            }
            database.close()
        }else {
            print("Error: \(database.lastErrorMessage())")
        }
        return tasks
    }
    
    func update(_ database: FMDatabase, _ record: AnyObject) -> Bool {
        var result = false;
        if database.open() {
            var updateSQL = "UPDATE task SET title=?, body=?, creation_date=?, expiration_date=?, difficulty=?, priority=?, completed=?, completition_date=? WHERE id=?"
            
            var data: Array<Any>
            let task = record as! Task
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let creationDateStr = formatter.string(from: task.creationDate)
            let expDateStr = formatter.string(from: task.expirationDate)
            
            if (task.completed) {
                let completedInt = 1
                
                let compDateStr = formatter.string(from: task.completitionDate!)
                
                data = ["\((record as! Task).title)", "\((record as! Task).body)",
                    "\(creationDateStr)", "\(expDateStr)",
                    "\((record as! Task).difficulty)", "\((record as! Task).priority)",
                    "\(completedInt)", "\(compDateStr)", "\((record as! Task).id ?? -1)"]
                
                result = database.executeUpdate(updateSQL, withArgumentsIn: data)
            }else {
                updateSQL = "UPDATE task SET title=?, body=?, creation_date=?, expiration_date=?, difficulty=?, priority=?, completed=0, completition_date=null WHERE id=?"
                
                data = ["\((record as! Task).title)", "\((record as! Task).body)",
                    "\(creationDateStr)", "\(expDateStr)",
                    "\((record as! Task).difficulty)", "\((record as! Task).priority)", "\((record as! Task).id ?? -1)"]
                
                result = database.executeUpdate(updateSQL, withArgumentsIn: data)
            }
            
            database.close()
        }else {
            print("Error: \(database.lastErrorMessage())")
        }
        return result
    }
    
    
    
    
    
    
}
