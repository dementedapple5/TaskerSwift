//
//  Task.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 19/03/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

import Foundation

class Task {
    var id: Int?
    var title: String
    var body: String
    var creationDate: Date
    var expirationDate: Date
    var difficulty: Int
    var priority: Int
    var completed: Bool
    var completitionDate: Date?
    
    
    
    init(_ title: String,_ body: String,_ expirationDate: Date,_ difficulty: Int,_ priority: Int) {
        self.title = title
        self.body = body
        self.expirationDate = expirationDate
        self.difficulty = difficulty
        self.priority = priority
        self.creationDate = Date()
        self.completed = false
    }
    
    init(_ id: Int,_ title: String,_ body: String,_ expirationDate: Date,_ difficulty: Int,_ priority: Int,_ creationDate: Date,_ completed: Bool,_ completitionDate: Date?) {
        self.id = id
        self.title = title
        self.body = body
        self.expirationDate = expirationDate
        self.difficulty = difficulty
        self.priority = priority
        self.creationDate = creationDate
        self.completed = completed
        self.completitionDate = completitionDate
    }
    
    func markAsDone() {
        self.completed = !self.completed
        if (self.completed) {
            self.completitionDate = Date()
        } else {
            self.completitionDate = nil
        }
    }
    
    func reformatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy-hh:mm"
        return formatter.string(from: date)
    }
    
    
    
    
    
}
