//
//  DetailPopupViewController.swift
//  ToDoList
//
//  Created by Richard Jo on 7/9/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit

class DetailPopupViewController: UIViewController {

    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var editTaskButton: UIView!
    @IBOutlet weak var deleteTaskButton: UIView!
    
    var updateDataDelegate:TasksViewControllerUpdateData?
    var editDataSegueDelegate:TaskDetailPopupEditDataSegue?
    
    var task:Task!
    
    @IBAction func dismissDetailPopupViewOnTouch(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        //Sets popup with task information
        taskNameLabel.text = task.name
        descriptionLabel.text = task.detail
        dateLabel.text = dateFormatter.string(from: task.dateDue as Date)
        
        let deleteGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteTaskButtonOnTouch))
        deleteTaskButton.addGestureRecognizer(deleteGestureRecognizer)
        
        let editGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editTaskButtonOnTouch))
        editTaskButton.addGestureRecognizer(editGestureRecognizer)
        
        //Sets shadow and rounded edges on edit/delete task button
        editTaskButton.layer.cornerRadius = 12
        editTaskButton.layer.shadowRadius = 3
        editTaskButton.layer.shadowOpacity = 0.3
        
        deleteTaskButton.layer.cornerRadius = 12
        deleteTaskButton.layer.shadowRadius = 3
        deleteTaskButton.layer.shadowOpacity = 0.3
    }
    
    @objc func deleteTaskButtonOnTouch(){
        updateDataDelegate!.deleteTask(task: task)
        dismiss(animated: true)
    }
    
    @objc func editTaskButtonOnTouch(){
        dismiss(animated: true)
        editDataSegueDelegate!.editData(task: task)
    }
    
}
