//
//  ViewController.swift
//  SnapchatMenu
//
//  Created by pike young on 2017/8/21.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    enum vcName : String {
        case chat = "ChatViewController"
        case stories = "StoriesViewController"
        case discover = "DiscoverViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Create view controllers and add them to current view controller.
        let chatVC = UIViewController(nibName: vcName.chat.rawValue, bundle: nil)
        let storiesVC = UIViewController(nibName: vcName.stories.rawValue, bundle: nil)
        let discoverVC = UIViewController(nibName: vcName.discover.rawValue, bundle: nil)
        add(childViewController: chatVC, toParentViewController: self)
        add(childViewController: storiesVC, toParentViewController: self)
        add(childViewController: discoverVC, toParentViewController: self)
        
        /// Set up current snap view.
        let snapView = UIImageView(image: UIImage(named: "Snap"))
        changeX(ofView: snapView, xPosition: view.frame.width)
        scrollView.addSubview(snapView)
        
        /// Move stories and discover view to the right screen.
        changeX(ofView: storiesVC.view, xPosition: view.frame.width * 2)
        changeX(ofView: discoverVC.view, xPosition: view.frame.width * 3)
        
        /// Set up contentSize and contentOffset.
        scrollView.contentSize = CGSize(width: view.frame.width * 4, height: view.frame.height)
        scrollView.contentOffset.x = view.frame.width
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    fileprivate func add(childViewController: UIViewController, toParentViewController parentViewController: UIViewController) {
        addChildViewController(childViewController)
        scrollView.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: parentViewController)
    }
    
    fileprivate func changeX(ofView view: UIView, xPosition: CGFloat) {
        var frame = view.frame
        frame.origin.x = xPosition
        view.frame = frame
    }
}

