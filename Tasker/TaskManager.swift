//
//  TaskManager.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 19/03/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

import Foundation

class TasksManager {
    var tasks: [Task] = [Task]()
    
    func addTask(task: Task) {
        tasks.append(task)
    }
    
    func deleteTask(index: Int) {
        tasks.remove(at: index)
    }
    
    func markTaskAsDone(index: Int) {
        tasks[index].markAsDone()
    }
    
}
