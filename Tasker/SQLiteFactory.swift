//
//  SQLiteFactory.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 08/04/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

import Foundation

class SQLiteFactory {
    class func createFactory()-> SQLiteDAO {
        return TasksManager()
    }
}
