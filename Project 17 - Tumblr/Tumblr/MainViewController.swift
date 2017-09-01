//
//  MainViewController.swift
//  Tumblr
//
//  Created by pike young on 2017/8/28.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove hairline
        navigationController?.toolbar.clipsToBounds = true
    }

}
