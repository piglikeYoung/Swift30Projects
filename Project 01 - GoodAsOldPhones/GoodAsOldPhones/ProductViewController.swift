//
//  ViewController.swift
//  GoodAsOldPhones
//
//  Created by pike young on 2017/7/25.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    var product: Product?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productNameLabel.text = product?.name
        
        if let imageName = product?.fullscreenImageName {
            productImageView.image = UIImage(named: imageName)
        }
    }
    
    @IBAction func productNameLabel(_ sender: Any) {
        print("Hello World")
    }
    
}

