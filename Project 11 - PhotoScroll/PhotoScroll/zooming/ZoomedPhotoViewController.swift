//
//  ZoomedPhotoViewController.swift
//  PhotoScroll
//
//  Created by pike young on 2017/8/14.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class ZoomedPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var photoName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: photoName)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScale(forSize: view.bounds.size)
    }
    
    fileprivate func updateConstraints(forSize size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    fileprivate func updateMinZoomScale(forSize size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        
        /// set up the init zoom scale
        scrollView.zoomScale = minScale
    }
}

extension ZoomedPhotoViewController: UIScrollViewDelegate {
    
    /// Tell the delegate that the imageView will be made smaller or bigger.
    ///
    /// - Parameter scrollView: scrollView delegate to current view controller
    /// - Returns: the view is zoomed in and out
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// Called every time zoom in or out the scroll View
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(forSize: view.bounds.size)
    }
}
