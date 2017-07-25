//
//  ContactViewController.swift
//  GoodAsOldPhones
//
//  Created by pike young on 2017/7/25.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: 375, height: 800)
    }

}
