//
//  SQLiteSingleton.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 08/04/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

import Foundation

private let databaseFileName: String = "task.db"
private var databasePath: String =  String()
private var database: FMDatabase?

class SQLiteSingleton {
    class func getInstance()-> FMDatabase {
        if (database == nil){
            let fileManager = FileManager()
            
            if let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
                let databaseURL = docsDir.appendingPathComponent(databaseFileName)
                databasePath = databaseURL.absoluteString
                database = FMDatabase(path: databasePath)
            }
        }
        return database!
    }
}
