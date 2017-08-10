//
//  LibraryAPI.swift
//  PokedexGo
//
//  Created by pike young on 2017/8/9.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {

    static let sharedInstance = LibraryAPI()
    let persistencyManager = PersistencyManager()
    
    fileprivate override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector:#selector(LibraryAPI.downloadImage(_:)), name: NSNotification.Name(rawValue: downloadImageNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getPokenmons() -> [Pokemon] {
        return pakemons
    }
    
    func downloadImg(_ url: String) -> (UIImage) {
        let aUrl = URL(string: url)
        let data = try? Data(contentsOf: aUrl!)
        let image = UIImage(data: data!)
        return image!
    }
    
    func downloadImage(_ notification: Notification) {
        // retrieve info from notification
        let userInfo = notification.userInfo!
        let pakeImageView = userInfo["pokeImageView"] as! UIImageView?
        let pokeImageUrl = userInfo["pokeImageUrl"] as! String
        
        if let imageViewUnWrapped = pakeImageView {
            imageViewUnWrapped.image = persistencyManager.getImage(URL(string: pokeImageUrl)!.lastPathComponent)
            if imageViewUnWrapped.image == nil {
                DispatchQueue.main.async {
                    let downloadedImage = self.downloadImg(pokeImageUrl)
                    DispatchQueue.main.async {
                        imageViewUnWrapped.image = downloadedImage
                        self.persistencyManager.saveImage(downloadedImage, filename: URL(string: pokeImageUrl)!.lastPathComponent)
                    }
                }
            }
        }
    }
}
