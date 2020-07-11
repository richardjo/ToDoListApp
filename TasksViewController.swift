//
//  ViewController.swift
//  ToDoList
//
//  Created by Richard Jo on 7/8/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit
import RealmSwift

protocol TaskDetailPopupEditDataSegue {
    func editData(task: Task)
}
protocol TaskDetailPopupView {
    func displayTaskDetailPopupView(task: Task)
}
protocol TasksViewControllerUpdateData {
    func deleteTask(task: Task)
    func updateIsCompletedTask(task: Task)
    func updateTask(task: Task, name: String, detail: String, date:Date)
    func addNewTask(task: Task)
}

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todayView: UIView!
    
    @IBOutlet weak var dateTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var addTaskButton: UIView!
    
    //toDoItems - returns array of incomplete task items
    var toDoItems:Array<Task>?{
        //Obtains Realm context to retrieve task data - if fails, returns nil
        guard let realm = LocalDatabaseManager.getRealmContext() else { return nil }
        //Retrieves incomplete tasks and orders them by due date
        let toDoTasks = Array(realm.objects(Task.self).filter({!$0.isCompleted}).sorted(by: { (firstTask, secondTask) -> Bool in
            //Compares dates and returns true if dates are in ascending order - else, returns false
            let comparison = firstTask.dateDue.compare(secondTask.dateDue as Date)
            return comparison == .orderedAscending
        }))
        return toDoTasks
    }
    
    //completedItems - returns array of completed task items
    var completedItems:Array<Task>?{
        //Obtains Realm context to retrieve task data - if fails, returns nil
        guard let realm = LocalDatabaseManager.getRealmContext() else { return nil }
        //Retrieves complete tasks and orders them by due date
        let completedTasks = Array(realm.objects(Task.self).filter({$0.isCompleted}).sorted(by: { (firstTask, secondTask) -> Bool in
            //Compares dates and returns true if dates are in ascending order - else, returns false
            let comparison = firstTask.dateDue.compare(secondTask.dateDue as Date)
            return comparison == .orderedAscending
        }))
        return completedTasks
    }
    
    //numberOfSections - returns number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        //Hides "completed" section if there are no "completed" tasks
        if completedItems != nil, completedItems!.isEmpty { return 1 }
        return 2
    }
    
    //titleForHeaderInSection - returns title header for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "To-Do"
        case 1:
            return "Completed"
        default:
            return ""
        }
    }
    
    //numberOfRowsInSection - returns number of rows in completed/to-do sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if toDoItems != nil { return toDoItems!.count }
            return 0
        case 1:
            if completedItems != nil { return completedItems!.count }
            return 0
        default:
            return 0
        }
    }
    
    //cellForRowAt - returns table view cell at each index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")
        
        if let taskTableViewCell = cell as? TaskTableViewCell {
            switch indexPath.section {
            case 0:
                //Sets task table view cell text and button information for incomplete tasks
                taskTableViewCell.taskLabel.text = toDoItems![indexPath.row].name
                taskTableViewCell.isCompleted = toDoItems![indexPath.row].isCompleted
                taskTableViewCell.task = toDoItems![indexPath.row]
                
                //Formats and sets date information
                let dueDate = toDoItems![indexPath.row].dateDue as Date
                let formattedData = taskTableViewCellDateFormatter(for: dueDate)
                taskTableViewCell.dueDateLabel.text = formattedData
            case 1:
                //Sets task table view cell text and button information for completed tasks
                taskTableViewCell.taskLabel.text = completedItems![indexPath.row].name
                taskTableViewCell.isCompleted = completedItems![indexPath.row].isCompleted
                taskTableViewCell.task = completedItems![indexPath.row]
                
                //Formats and sets date information
                let dueDate = completedItems![indexPath.row].dateDue as Date
                let formattedData = taskTableViewCellDateFormatter(for: dueDate)
                taskTableViewCell.dueDateLabel.text = formattedData
            default:
                break
            }
            //Sets task table view cell delegate and data information
            taskTableViewCell.updateDataDelegate = self
            taskTableViewCell.taskDetailPopupDelegate = self
            
            //Sets selected background color to "clear"
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            taskTableViewCell.selectedBackgroundView = backgroundView
            
            //Sets data update delegate to the view controller
            return taskTableViewCell
        }
        return UITableViewCell()
    }
    
    private func taskTableViewCellDateFormatter(for date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        
        //Sets up date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        var formattedDate = ""
        
        //Returns formatted date depending on whether it's today, tomorrow, etc
        if calendar.isDateInToday(date) {
            formattedDate = "Today"
        } else if calendar.isDateInTomorrow(date) {
            formattedDate = "Tomorrow"
        } else if Date().compare(date) == .orderedDescending {
            formattedDate = "Overdue"
        } else {
            formattedDate = dateFormatter.string(from: date)
        }
        
        return formattedDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Eliminates table view lines
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //Sets date label to today's date
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, y"
        dateTitle.text = dateFormatter.string(from: currentDate)
        //Sets shadow on date view
        todayView.layer.shadowRadius = 7
        todayView.layer.shadowOpacity = 0.75
        
        //Sets shadow and rounded edges on add task button
        addTaskButton.layer.cornerRadius = 12
        addTaskButton.layer.shadowRadius = 3
        addTaskButton.layer.shadowOpacity = 0.3
        //Adds tap gesture recognizer to add task button
        let addTaskGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addTaskButtonOnTouch))
        addTaskButton.addGestureRecognizer(addTaskGestureRecognizer)
        
        //Adds inset to bottom of table view
        let tableViewInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(20), right: 0)
        tableView.contentInset = tableViewInset
        tableView.scrollIndicatorInsets = tableViewInset
    }
    
    @objc func addTaskButtonOnTouch(){
        performSegue(withIdentifier: "newTaskSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "newTaskSegue":
            if let destination = segue.destination as? NewTaskViewController {
                destination.updateDataDelegate = self
            }
        case "editTaskSegue":
            if let destination = segue.destination as?  EditTaskViewController {
            if let task = sender as? Task {
                    destination.updateDataDelegate = self
                    destination.task = task
                }
            }
        case "detailPopupSegue":
            if let destination = segue.destination as? DetailPopupViewController {
                if let task = sender as? Task {
                    destination.updateDataDelegate = self
                    destination.editDataSegueDelegate = self
                    destination.task = task
                }
            }
        default:
            break
        }
    }
}

//TasksViewControllerUpdateData - updates and reloads task data
extension TasksViewController: TasksViewControllerUpdateData {
    //deleteTask - deletes existing task
    func deleteTask(task: Task) {
        
        guard let realm = LocalDatabaseManager.getRealmContext() else { return }
        do {
            try realm.write {
                realm.delete(task)
            }
            tableView.reloadData()
        } catch {
            return
        }
    }
    
    //updateTask - updates existing task
    func updateTask(task: Task, name: String, detail: String, date:Date) {
        guard let realm = LocalDatabaseManager.getRealmContext() else { return }
        do {
            try realm.write {
                task.name = name
                task.detail = detail
                task.dateDue = date as NSDate
            }
            tableView.reloadData()
        } catch {
            return
        }
    }
    
    //addsNewTask - saves new task
    func addNewTask(task: Task) {
        guard let realm = LocalDatabaseManager.getRealmContext() else { return }
        do {
            try realm.write {
                realm.add(task)
            }
            tableView.reloadData()
        } catch {
            return
        }
    }
    
    //updateIsCompletedTask - updates tasks completion data
    func updateIsCompletedTask(task: Task) {
        //Obtains Realm context
        guard let realm = LocalDatabaseManager.getRealmContext() else { return }
        
        do {
            //Completes or un-completes task
            try realm.write {
                task.isCompleted = !task.isCompleted
            }
            tableView.reloadData()
        } catch {
            return
        }
    }
}

//TasksDetailPopupView - modally presents task detail popup view when task is clicked
extension TasksViewController: TaskDetailPopupView {
    func displayTaskDetailPopupView(task: Task) {
        performSegue(withIdentifier: "detailPopupSegue", sender: task)
    }
}

extension TasksViewController: TaskDetailPopupEditDataSegue {
    func editData(task: Task) {
        performSegue(withIdentifier: "editTaskSegue", sender: task)
    }
}
