//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by pike young on 2017/9/11.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath,
                        withWidth:CGFloat) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}


class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    var photoHeight: CGFloat = 0.0
    
    // override the method to ensure photoHeight is set when copied
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    // compare photoHeight of attributes
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if( attributes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class PinterestLayout: UICollectionViewLayout {
    var delegate: PinterestLayoutDelegate!
    
    // 2列
    var numberOfColumns = 2
    // 间距
    var cellPadding: CGFloat = 6.0
    
    fileprivate var cache = [PinterestLayoutAttributes]()
    // 容器高度
    fileprivate var contentHeight: CGFloat  = 0.0
    // 容器宽度
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        if cache.isEmpty {
            // get column width
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            
            // set up xOffset
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            
            // set up yOffset
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            // set up every item
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                // Item宽度
                let width = columnWidth - cellPadding * 2
                // 图片高度
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
                // 文字内容高度
                let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                // 总高度 = 顶部间距 + 图片高度 + 文字高度 + 底部间距
                let height = cellPadding + photoHeight + annotationHeight + cellPadding
                // Item 的 frame
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                // 留出顶部间距+底部间距
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // cache attributes for each item
                // 缓存每个item的属性
                let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 计算添加每个Item后，容器的高度
                contentHeight = max(contentHeight, frame.maxY)
                // 累积每列的高度，每次都在底部添加Item
                yOffset[column] = yOffset[column] + height
                
                // 第0列和第1列切换
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        // 取出缓存中的属性
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
    
    override class var layoutAttributesClass : AnyClass {
        return PinterestLayoutAttributes.self
    }
}
