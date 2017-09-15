//
//  ContactBirthdayCell.swift
//  Birthdays
//
//  Created by pike young on 2017/9/14.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class ContactBirthdayCell: UITableViewCell {

    @IBOutlet weak var imgContactImage: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgContactImage.layer.cornerRadius = 25.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
