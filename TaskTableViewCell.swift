//
//  taskTableViewCell.swift
//  ToDoList
//
//  Created by Richard Jo on 7/8/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var updateDataDelegate:TasksViewControllerUpdateData?
    var taskDetailPopupDelegate: TaskDetailPopupView?
    
    var task:Task!

    var isCompleted:Bool = false {
        didSet {
            if isCompleted {
                completionButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                completionButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
    }
    @IBOutlet weak var dueDateLabel: UILabel! {
        didSet {
            dueDateLabel.sizeToFit()
        }
    }
    
    @IBOutlet var completionButton: UIButton!
    
    @IBAction func detailButton(_ sender: UIButton) {
        taskDetailPopupDelegate!.displayTaskDetailPopupView(task: task)
    }
    
    //Updates button and model to represent completed task
    @IBAction func completionButtonPressed(_ sender: UIButton) {
        if updateDataDelegate != nil {
            isCompleted = !isCompleted
            updateDataDelegate!.updateIsCompletedTask(task: task)
        }
    }
    
    @IBOutlet weak var taskLabel: UILabel! {
        didSet {
            taskLabel.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
