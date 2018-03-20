//
//  AddTaskViewController.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 19/03/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var mTaskTitle: UITextField!
    @IBOutlet weak var mTaskBody: UITextField!
    @IBOutlet weak var mTaskDifficulty: UISegmentedControl!
    @IBOutlet weak var mTaskPrior: UISegmentedControl!
    @IBOutlet weak var mTaskExpDate: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var newTask: Task?
        if segue.identifier == "Save Segue" {
            if checkExpDate(expDate: mTaskExpDate.date) {
                if let taskTitle = mTaskTitle.text {
                    if let taskBody = mTaskBody.text {
                        let difficulty = mTaskDifficulty.selectedSegmentIndex
                        let priority = mTaskPrior.selectedSegmentIndex
                        let expDate = mTaskExpDate.date
                        
                        newTask = Task(taskTitle, taskBody, expDate, difficulty, priority)
                        
                        guard let todoTableVC = segue.destination as? TODOTableViewController else {return}
                        
                        todoTableVC.newTask = newTask
                    }
                }
                
            }
            
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        
        
        // Pass the selected object to the new view controller.
    }
    
    func checkExpDate(expDate: Date) -> Bool {
        if expDate < Date() {
            let alert = UIAlertController(title: "Please change the Expiration Date", message: "The Expiration Date should be greater tha the actual date", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            
            self.present(alert, animated: true)
            
            return false
        }
        
        return true
    }

}
