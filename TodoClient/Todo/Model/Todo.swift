
//
//  Todo.swift
//  Todo
//
//  Created by Corotata on 2018/7/6.
//  Copyright © 2018 Corotata. All rights reserved.
//

import Foundation
import HandyJSON

struct Todo: HandyJSON {
    var id: Int?
    var title: String?
    var createAt: TimeInterval?
    var modifyAt: TimeInterval?
    var isFinish: Bool = false
}
