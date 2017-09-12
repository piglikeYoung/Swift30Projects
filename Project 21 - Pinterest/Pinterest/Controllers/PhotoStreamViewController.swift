//
//  PhotoStreamViewController.swift
//  Pinterest
//
//  Created by pike young on 2017/9/11.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "AnnotatedPhotoCell"

class PhotoStreamViewController: UICollectionViewController {
    
    var photos = Photo.allPhotos()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 转换collectionViewLayout
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
    }
}

extension PhotoStreamViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AnnotatedPhotoCell
        cell.photo = photos[indexPath.item]
        return cell
    }
}

extension PhotoStreamViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let photo = photos[(indexPath as NSIndexPath).item]
        // 图片需要在多大的Frame显示
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        // 图片按照Frame等比例缩小居中显示后，图片的Frame，等比例缩放后，图片的高度也等比例缩放了，不能直接使用 photo.image.size.height
        let rect  = AVMakeRect(aspectRatio: photo.image.size, insideRect: boundingRect)
        // 图片的高度
        return rect.size.height
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        let photo = photos[indexPath.item]
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight = photo.heightForComment(font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
    }
}
