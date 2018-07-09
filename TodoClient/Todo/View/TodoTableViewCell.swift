//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by Corotata on 2018/7/6.
//  Copyright © 2018 Corotata. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    var todo: Todo? {
        didSet {
            guard  let todo = todo else {
                return
            }
            todoTitleLabel.text = todo.title
            finishButton.setTitle(todo.isFinish ? "Finish": "Unfinish", for: .normal)
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
