//
//  FBMeUser.swift
//  FBMeUser
//
//  Created by pike young on 2017/8/10.
//  Copyright © 2017年 pike young. All rights reserved.
//

import Foundation

struct FBMeUser {
    var name: String
    var avatarName: String
    var education: String
    
    init(name: String, avatarName: String = "bayMax", education: String) {
        self.name = name
        self.avatarName = avatarName
        self.education = education
    }
}
