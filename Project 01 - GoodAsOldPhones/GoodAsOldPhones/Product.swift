//
//  Product.swift
//  GoodAsOldPhones
//
//  Created by pike young on 2017/7/25.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class Product: NSObject {
    var name: String?
    var cellImageName: String?
    var fullscreenImageName: String?
    
    init(name: String, cellImageName: String, fullscreenImageName: String) {
        self.name = name;
        self.cellImageName = cellImageName
        self.fullscreenImageName = fullscreenImageName
    }
    
}
