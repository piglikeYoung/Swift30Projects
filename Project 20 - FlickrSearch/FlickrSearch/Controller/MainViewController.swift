//
//  MainViewController.swift
//  FlickrSearch
//
//  Created by pike young on 2017/9/5.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let headerViewIdentifier = "FlickrPhotoHeaderView"
    fileprivate let reuseIdentifier = "FlickrCell"
    fileprivate let sectionInsets = UIEdgeInsetsMake(50.0, 20.0, 50.0, 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate var searches = [FlickrSearchResults]()
    fileprivate let flickr = Flickr()
    
    // support multiple photos selections
    fileprivate var selectedPhotos = [FlickrPhoto]()
    fileprivate let shareTextLabel = UILabel()
    
    fileprivate var largePhotoIndexPath: IndexPath? {
        didSet {
            var indexPaths = [IndexPath]()
            
            // 添加新选中的item的IndexPath
            if let largePhotoIndexPath = largePhotoIndexPath {
                indexPaths.append(largePhotoIndexPath)
            }
            
            // 添加前一个选中的item的IndexPath
            if let oldValue = oldValue {
                indexPaths.append(oldValue)
            }
            
            // 批量更新
            collectionView.performBatchUpdates({
                // 刷新数组里的item
                self.collectionView.reloadItems(at: indexPaths)
            }) { (completed) in
                if let largePhotoIndexPath = self.largePhotoIndexPath {
                    // 滚到大图的中心
                    self.collectionView.scrollToItem(at: largePhotoIndexPath, at: .centeredVertically, animated: true)
                }
            }
        }
    }
    
    var sharing: Bool = false {
        didSet {
            // reset collectionView and selectedPhotos
            // 允许多选
            collectionView.allowsMultipleSelection = sharing
            // 取消之前选中（选中一个空值就好了）
            collectionView.selectItem(at: nil, animated: true, scrollPosition: UICollectionViewScrollPosition())
            // 移除之前所以的选中
            selectedPhotos.removeAll(keepingCapacity: false)
            
            // 判断分享按钮在不在
            guard let shareButton = self.navigationItem.rightBarButtonItems?.first else {
                return
            }
            
            // 不是分享，只有一个分享按钮
            guard sharing else {
                navigationItem.setRightBarButtonItems([shareButton], animated: true)
                return
            }
            
            if let _ = largePhotoIndexPath  {
                largePhotoIndexPath = nil
            }
            
            updateSharedPhotoCount()
            // 是分享，navigationRightItem 增加一个选中数量Label
            let sharingDetailItem = UIBarButtonItem(customView: shareTextLabel)
            navigationItem.setRightBarButtonItems([shareButton, sharingDetailItem], animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // 长按调整图片位置
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector.longTagHundle)
        collectionView.addGestureRecognizer(longPressGesture)
    }

    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            // 长按的那个Cell IndexPath
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @IBAction func shareButtonDidTap(_ sender: UIBarButtonItem) {
        
        // 图片列表为空，返回
        guard !searches.isEmpty else {
            return
        }
        
        // 选择图片为空，说明第一次点击
        guard !selectedPhotos.isEmpty else {
            sharing = !sharing
            return
        }
        
        guard sharing else {
            return
        }
        
        // won't be executed when first tapped
        var imageArray = [UIImage]()
        // 遍历选中的图片
        for selectedPhoto in selectedPhotos {
            if let thumbnail = selectedPhoto.thumbnail {
                imageArray.append(thumbnail)
            }
        }
        
        // present activityViewController when imageArray has some selected
        // 弹出分享框
        if !imageArray.isEmpty {
            let shareScreen = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
            shareScreen.completionWithItemsHandler = { _ in
                self.sharing = false
            }
            
            let popoverPresentationController = shareScreen.popoverPresentationController
            popoverPresentationController?.barButtonItem = sender
            popoverPresentationController?.permittedArrowDirections = .any
            present(shareScreen, animated: true, completion: nil)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        
        cell.activityIndicator.stopAnimating()
        
        // 不是大图的IndexPath，显示小图
        guard indexPath == largePhotoIndexPath else {
            cell.imageView.image = flickrPhoto.thumbnail
            return cell
        }
        
        // if already loaded large image
        // 已经下载了大图，直接赋值
        guard flickrPhoto.largeImage == nil else {
            cell.imageView.image = flickrPhoto.largeImage
            return cell
        }
        
        // start loading large image
        // 开始下载大图
        cell.imageView.image = flickrPhoto.thumbnail
        cell.activityIndicator.startAnimating()
        
        flickrPhoto.loadLargeImage { (loadedFlickrPhoto, error) in
            cell.activityIndicator.stopAnimating()
            
            guard loadedFlickrPhoto.largeImage != nil && error == nil else {
                return
            }
            
            // 因为这里 collectionView.cellForItem ，相当于回调里调用自己，所以 loadLargeImage 使用 @escaping 逃逸
            if let cell = collectionView.cellForItem(at: indexPath) as? FlickrPhotoCell,
                indexPath == self.largePhotoIndexPath  {
                // 显示大图
                cell.imageView.image = loadedFlickrPhoto.largeImage
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as! FlickrPhotoHeaderView
            headerView.titleLabel.text = searches[indexPath.section].searchTerm
            return headerView
            
        default:
            assert(false, "Unexpected element kind");
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var sourceResults = searches[sourceIndexPath.section].searchResults
        let flickrPhoto = sourceResults.remove(at: sourceIndexPath.row)
        
        var destinationResults = searches[sourceIndexPath.section].searchResults
        destinationResults.insert(flickrPhoto, at: destinationIndexPath.row)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 小图和大图显示的size不一样
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        if indexPath == largePhotoIndexPath {
            let flickrPhoto = photoForIndexPath(indexPath: indexPath)
            var size = collectionView.bounds.size
            size.height -= topLayoutGuide.length
            size.height -= (sectionInsets.top + sectionInsets.right)
            size.width -= (sectionInsets.left + sectionInsets.right)
            return flickrPhoto.sizeToFillWidthOfSize(size)
        }
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // 如果是分享选择，选中
        guard !sharing else {
            return true
        }
        // 非分享，显示大图
        largePhotoIndexPath = largePhotoIndexPath == indexPath ? nil : indexPath
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard sharing else {
            return
        }
        
        let photo = photoForIndexPath(indexPath: indexPath)
        selectedPhotos.append(photo)
        updateSharedPhotoCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard sharing else {
            return
        }
        
        let photo = photoForIndexPath(indexPath: indexPath)
        
        if let index = selectedPhotos.index(of: photo) {
            selectedPhotos.remove(at: index)
            updateSharedPhotoCount()
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    
    // 点击return，开始搜索
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        // 网络搜索
        flickr.searchFlickrForTerm(textField.text!) { (results, error) in
            activityIndicator.removeFromSuperview()
            
            if let error = error {
                print("Error searching: \(error)")
                return
            }
            
            if let results = results {
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                
                self.collectionView?.reloadData()
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - Private

private extension MainViewController {
    
    /// 根据IndexPath获取数据源数据
    ///
    /// - Parameter indexPath: 路径
    /// - Returns: 数据
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
    /// 更新分享的选中图片数量
    func updateSharedPhotoCount() {
        shareTextLabel.textColor = themeColor
        shareTextLabel.text = "\(selectedPhotos.count) photos selected"
        shareTextLabel.sizeToFit()
    }
}

private extension Selector {
    static let longTagHundle = #selector(MainViewController.handleLongGesture(gesture:))
}
