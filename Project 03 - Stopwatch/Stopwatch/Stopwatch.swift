//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by pike young on 2017/7/26.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class Stopwatch: NSObject {
    var counter: Double
    var timer: Timer
    
    override init() {
        counter = 0.0
        timer = Timer()
    }
}
