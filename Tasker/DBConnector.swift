//
//  DBConnector.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 19/03/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

/*

import Foundation

private let dataBaseFileName: String = "carShop.db"
private var databasePath: String = String()

private var database: FMDatabase?

class DBConnector{
    
    class func getInstance()-> FMDatabase{
        if (database == nil){
            let fileManager = FileManager()
            
            if let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
                let databaseURL = docsDir.appendingPathComponent(dataBaseFileName)
                databasePath = databaseURL.absoluteString
                database = FMDatabase(path: databasePath)
            }
        }
        return database!
    }
}
 
*/
