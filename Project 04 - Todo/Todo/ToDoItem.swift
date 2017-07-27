//
//  ToDoItem.swift
//  Todo
//
//  Created by pike young on 2017/7/27.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    var id: String
    var image: String
    var title: String
    var date: Date
    
    init(id: String, image: String, title: String, date: Date) {
        self.id = id
        self.image = image
        self.title = title
        self.date = date
    }
}
