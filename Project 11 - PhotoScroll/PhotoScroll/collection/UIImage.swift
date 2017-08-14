//
//  UIImage.swift
//  PhotoScroll
//
//  Created by pike young on 2017/8/14.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

extension UIImage {
    func thumbnailOfSize(_ size: CGFloat) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        UIGraphicsBeginImageContext(rect.size)
        draw(in: rect)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return thumbnail!
    }
}
