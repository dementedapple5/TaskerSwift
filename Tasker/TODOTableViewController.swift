//
//  TODOTableViewController.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 19/03/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

import UIKit

class TODOTableViewController: UITableViewController {
    
    var taskSegue: Task?
    
    
    var database:FMDatabase = SQLiteSingleton.getInstance()
    var taskManager:TasksManager = (SQLiteFactory.createFactory() as! TasksManager)
    
    @IBOutlet weak var mEditBtn: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatabase()
        print(FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.absoluteString)
        
        taskManager.tasks = taskManager.readRecords(database, 0) as! Array<Task>
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func goBack(segue: UIStoryboardSegue){
        taskManager.tasks = taskManager.readRecords(database, 0) as! Array<Task>
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskManager.tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = taskManager.tasks[indexPath.row].title
        cell.detailTextLabel?.text = reformatDate(date: taskManager.tasks[indexPath.row].creationDate)
        cell.detailTextLabel?.textColor = UIColor.lightGray
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
        cell.addGestureRecognizer(longPressGesture)
        return cell
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let task = taskManager.tasks[fromIndexPath.row]
        taskManager.tasks.remove(at: fromIndexPath.row)
        taskManager.tasks.insert(task, at: to.row)
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addTaskVC = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                taskSegue = taskManager.tasks[indexPath.row]
                addTaskVC.task = taskSegue
                self.navigationController?.pushViewController(addTaskVC, animated: true)
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addTaskVC = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        let showDetailsVC = storyboard.instantiateViewController(withIdentifier: "TaskDetailsController") as! TaskDetailsViewController
        
        taskSegue = taskManager.tasks[indexPath.row]
        
        if self.isEditing {
            addTaskVC.task = taskSegue
            self.navigationController?.pushViewController(addTaskVC, animated: true)
        }else {
            showDetailsVC.task = taskSegue
            self.navigationController?.pushViewController(showDetailsVC, animated: true)
        }
        
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    @IBAction func onEdit(_ sender: UIBarButtonItem) {
        self.isEditing = !self.isEditing
        switch self.isEditing {
        case true:
            mEditBtn.title = "Done"
        default:
            mEditBtn.title = "Edit"
        }
    }
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
        if (taskManager.delete(database, taskManager.tasks[indexPath.row].id! as AnyObject)) {
            print("Deleted successfully")
        }
        taskManager.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
    
    
    func reformatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy-hh:mm"
        return formatter.string(from: date)
    }
    
    //init(_ id: Int,_ title: String,_ body: String,_ expirationDate: Date,_ difficulty: Int,_ priority: Int,_ creationDate: Date,_ completed:
    func setupDatabase() {
        if database.open() {
            //let dropTable = "DROP TABLE TASK"
            
            let createSQL = "CREATE TABLE IF NOT EXISTS TASK (id INTEGER PRIMARY KEY, title TEXT NOT NULL, body TEXT, expiration_date TEXT, difficulty INTEGER, priority INTEGER, creation_date TEXT, completed INTEGER, completition_date TEXT)"
            /*
            if !database.executeStatements(dropTable) {
                print("Error: \(database.lastErrorMessage())")
                
            }else {
                print("OK")
            }*/
            if !database.executeStatements(createSQL) {
                print("Error: \(database.lastErrorMessage())")
                
            }else {
                print("OK")
            }
            database.close()
        } else {
            print ("Error: \(database.lastErrorMessage())")
        }
    }

}
