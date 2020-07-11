//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Richard Jo on 7/9/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var taskDetailsTextField: UITextField!
    
    @IBOutlet weak var addTaskButton: UIView!
    
    var updateDataDelegate:TasksViewControllerUpdateData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Sets shadows and rounded edges on add task button
        addTaskButton.layer.cornerRadius = 12
        addTaskButton.layer.shadowRadius = 3
        addTaskButton.layer.shadowOpacity = 0.3
        //Adds tap gesture recognizer to add task button
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addTask))
        addTaskButton.addGestureRecognizer(gestureRecognizer)
    }

    @objc func addTask(){
        //Stores new task and returns to task view controller
        guard let taskNameTextInput = taskNameTextField.text else { return }
        
        guard let taskDetailsTextInput = taskDetailsTextField.text else { return }
        
        let task = Task(name: taskNameTextInput, detail: taskDetailsTextInput, dateDue: datePicker.date as NSDate)
        
        updateDataDelegate?.addNewTask(task: task)
        
        dismiss(animated: true)
    }
}
