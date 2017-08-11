//
//  FBMeBaseCell.swift
//  FBMeUser
//
//  Created by pike young on 2017/8/10.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class FBMeBaseCell: UITableViewCell {

    static let identifier = "FBMeBaseCell"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
