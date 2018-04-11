//
//  AddTaskViewController.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 19/03/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var mTaskTitle: UITextField!
    @IBOutlet weak var mTaskBody: UITextView!
    @IBOutlet weak var mTaskDifficulty: UISegmentedControl!
    @IBOutlet weak var mTaskPrior: UISegmentedControl!
    @IBOutlet weak var mTaskExpDate: UIDatePicker!
    @IBOutlet weak var mCompleteTask: UIButton!
    @IBOutlet weak var mAddTask: UIBarButtonItem!
    
    var task: Task?
    
    let taskManager = SQLiteFactory.createFactory() as! TasksManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTaskTitle.delegate = self
        mTaskBody.delegate = self
        
        mTaskBody.layer.borderColor = UIColor.lightGray.cgColor
        mTaskBody.layer.borderWidth = 1.0
        mTaskBody.layer.cornerRadius = 5.0
        
        fillFieldsIfEditing()
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(AddTaskViewController.keyboardWillShow(_:)), name:
            Notification.Name.UIKeyboardWillShow, object: view.window)
        
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(AddTaskViewController.keyboardWillHide(_:)), name:
            Notification.Name.UIKeyboardWillHide, object: view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fillFieldsIfEditing(){
        if (task != nil){
            print("EXP_DATE::", task!.expirationDate)
            print("PRIOR::", task!.priority)
            print("DIFF::", task!.difficulty)
            mTaskTitle.text = task?.title
            mTaskBody.text = task?.body
            mTaskPrior.selectedSegmentIndex = task!.priority
            mTaskDifficulty.selectedSegmentIndex = task!.difficulty
            mTaskExpDate.date = task!.expirationDate
            mCompleteTask.setTitle("Uncomplete", for: .normal)
            mAddTask.title = "Save"
            mCompleteTask.isHidden = false
            mCompleteTask.isEnabled = true
        }else {
            mCompleteTask.isHidden = true
            mCompleteTask.isEnabled = false
        }
    }
    
    @IBAction func onCompleteTask(_ sender: UIButton) {
        if (task != nil) {
            task?.markAsDone()
            if (task!.completed) {
                mCompleteTask.setTitle("Uncomplete", for: .normal)
                
            }else {
                mCompleteTask.setTitle("Complete", for: .normal)
            }
        }
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
    
    func createAlert(_ title: String,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onAddTask(_ sender: UIBarButtonItem) {
        
        var newTask: Task?
        if checkExpDate(expDate: mTaskExpDate.date) {
            if let taskTitle = mTaskTitle.text {
                if let taskBody = mTaskBody.text {
                    let difficulty = mTaskDifficulty.selectedSegmentIndex
                    let priority = mTaskPrior.selectedSegmentIndex
                    let expDate = mTaskExpDate.date
                    
                    if (task != nil) {
                        task!.body = taskBody
                        task!.title = taskTitle
                        task!.difficulty = difficulty
                        task!.priority = priority
                        task!.expirationDate = expDate
                        if (taskManager.update(SQLiteSingleton.getInstance(), task!)) {
                            createAlert("Task Updated", "The task has been successfully updated")
                            print(task!.id ?? -2)
                            print(task!.title)
                            print(task!.completed)
                        }else {
                            createAlert("Error", "There was an error while creting the task :(")
                        }
                    }else {
                        newTask = Task(taskTitle, taskBody, expDate, difficulty, priority)
                        if (taskManager.insert(SQLiteSingleton.getInstance(), newTask!)) {
                            createAlert("Task Created", "The task has been successfully created")
                        }else {
                            createAlert("Error", "There was an error while creting the task :(")
                        }
                    }
                    
                }
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender:Notification){
        self.view.frame.origin.y-=20
    }
    
    @objc func keyboardWillHide(_ sender:Notification){
        self.view.frame.origin.y+=40
    }
    

}
