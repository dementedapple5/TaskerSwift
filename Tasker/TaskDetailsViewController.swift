//
//  TaskDetailsViewController.swift
//  Tasker
//
//  Created by Daniel de la Lastra on 09/04/2018.
//  Copyright © 2018 Daniel de la Lastra. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    var task: Task?

    @IBOutlet weak var mTaskTitle: UILabel!
    @IBOutlet weak var mTaskBody: UITextView!
    @IBOutlet weak var mTaskDateRange: UILabel!
    @IBOutlet weak var mTaskDifficulty: UISegmentedControl!
    @IBOutlet weak var mTaskPriority: UISegmentedControl!
    @IBOutlet weak var mFinishedLbl: UILabel!
    @IBOutlet weak var mFinishedDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let creationDateStr = formatter.string(from: task!.creationDate)
        let expDateStr = formatter.string(from: task!.expirationDate)
        
        mTaskTitle.text = task?.title
        mTaskBody.text = task?.body
        
        if (task!.expirationDate < Date()) {
            mTaskDateRange.text = "From \(creationDateStr) to \(expDateStr) (Expired)"
            mTaskDateRange.textColor = UIColor.red
        }else {
            let calendar = Calendar.current
            let dateFrom = calendar.startOfDay(for: Date())
            let dateTo = calendar.startOfDay(for: task!.expirationDate)
            let totalDays = calendar.dateComponents([.day], from: dateFrom, to: dateTo).day
           mTaskDateRange.text = "From \(creationDateStr) to \(expDateStr) (\(totalDays!) Days left)"
            
            mTaskDateRange.textColor = UIColor.blue
        }
        if task!.completed {
            let compDateStr = formatter.string(from: task!.completitionDate!)
            mFinishedDate.text = compDateStr
        }else {
            mFinishedLbl.isHidden = true
            mFinishedDate.isHidden = true
        }
        
        mTaskPriority.selectedSegmentIndex = task!.priority
        mTaskDifficulty.selectedSegmentIndex = task!.difficulty
        mTaskPriority.isEnabled = false
        mTaskDifficulty.isEnabled = false
        mTaskBody.isEditable = false
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
