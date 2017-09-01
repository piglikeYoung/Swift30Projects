//
//  MenuViewController.swift
//  Tumblr
//
//  Created by pike young on 2017/8/28.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    let transitionManager = TransitionManager()

    // MARK: - IBOutlets
    @IBOutlet weak var textPostIcon: UIImageView!
    @IBOutlet weak var textPostLabel: UILabel!
    
    @IBOutlet weak var photoPostIcon: UIImageView!
    @IBOutlet weak var photoPostLabel: UILabel!
    
    @IBOutlet weak var quotePostIcon: UIImageView!
    @IBOutlet weak var quotePostLabel: UILabel!
    
    @IBOutlet weak var linkPostIcon: UIImageView!
    @IBOutlet weak var linkPostLabel: UILabel!
    
    @IBOutlet weak var chatPostIcon: UIImageView!
    @IBOutlet weak var chatPostLabel: UILabel!
    
    @IBOutlet weak var audioPostIcon: UIImageView!
    @IBOutlet weak var audioPostLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self.transitionManager
    }

    @IBAction func unwindToMainViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
