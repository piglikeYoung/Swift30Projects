//
//  Photo.swift
//  Pinterest
//
//  Created by pike young on 2017/9/11.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit


class Photo {
    
    /// 加载Plist，获取全部图片Model
    ///
    /// - Returns: 图片数组
    class func allPhotos() -> [Photo] {
        var photos = [Photo]()
        if let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist") {
            if let photosFromPlist = NSArray(contentsOf: URL) {
                for dictionary in photosFromPlist {
                    let photo = Photo(dictionary: dictionary as! NSDictionary)
                    photos.append(photo)
                }
            }
        }
        return photos
    }
    
    var caption: String
    var comment: String
    var image: UIImage
    
    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }
    
    convenience init(dictionary: NSDictionary) {
        let caption = dictionary["Caption"] as? String
        let comment = dictionary["Comment"] as? String
        let photo = dictionary["Photo"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(caption: caption!, comment: comment!, image: image!)
    }
    
    /// 计算Label的高度
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 最大宽度
    /// - Returns: Label 高度
    func heightForComment(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: comment).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
