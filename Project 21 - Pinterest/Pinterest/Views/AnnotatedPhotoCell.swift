//
//  AnnotatedPhotoCell.swift
//  Pinterest
//
//  Created by pike young on 2017/9/11.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var commentLabel: UILabel!
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                imageView.image = photo.image
                captionLabel.text = photo.caption
                commentLabel.text = photo.comment
            }
        }
    }
    
    /// 重载layout绑定，根据图片高度调整Cell的高度
    ///
    /// - Parameter layoutAttributes: layout属性
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
