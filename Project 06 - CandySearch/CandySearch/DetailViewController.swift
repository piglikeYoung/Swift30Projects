//
//  DetailViewController.swift
//  CandySearch
//
//  Created by pike young on 2017/8/9.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var candyImageView: UIImageView!

    var detailCandy: Candy? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailCandy = detailCandy {
            if let detailDescriptionLabel = detailDescriptionLabel, let candyImageView = candyImageView {
                detailDescriptionLabel.text = detailCandy.name
                candyImageView.image = UIImage(named: detailCandy.name)
                title = detailCandy.category
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

