//
//  EditTaskViewController.swift
//  ToDoList
//
//  Created by Richard Jo on 7/10/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var taskDetailsTextField: UITextField!
    
    var task:Task!
    
    @IBOutlet weak var editTaskButton: UIView!
    
    var updateDataDelegate:TasksViewControllerUpdateData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Sets text based on task information
        taskNameTextField.text = task.name
        taskDetailsTextField.text = task.detail
        datePicker.date = task.dateDue as Date
        //Sets shadows and rounded edges on add task button
        editTaskButton.layer.cornerRadius = 12
        editTaskButton.layer.shadowRadius = 3
        editTaskButton.layer.shadowOpacity = 0.3
        //Adds tap gesture recognizer to add task button
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editTask))
        editTaskButton.addGestureRecognizer(gestureRecognizer)
    }

    @objc func editTask(){
        //Stores new task and returns to task view controller
        guard let taskNameTextInput = taskNameTextField.text else { return }
        guard let taskDetailsTextInput = taskDetailsTextField.text else { return }
        print(taskNameTextInput)
        updateDataDelegate!.updateTask(task: task, name: taskNameTextInput, detail: taskDetailsTextInput, date: datePicker.date)
        dismiss(animated: true)
    }
}
