//
//  RoundedCornersView.swift
//  Pinterest
//
//  Created by pike young on 2017/9/11.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {

    // 画圆角
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
