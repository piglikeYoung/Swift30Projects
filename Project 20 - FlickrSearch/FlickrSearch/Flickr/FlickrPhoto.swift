//
//  FlickrPhoto.swift
//  FlickrSearch
//
//  Created by pike young on 2017/9/5.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class FlickrPhoto: Equatable {
    var thumbnail : UIImage?
    var largeImage : UIImage?
    let photoID : String
    let farm : Int
    let server : String
    let secret : String
    
    init(photoID:String,farm:Int, server:String, secret:String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
    }
    
    
    /// 图片地址
    ///
    /// - Parameter size: 图片大小
    /// - Returns: 图片地址
    func flickrImageURL(_ size: String = "m") -> URL? {
        if let url = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
            return url
        }
        return nil;
    }
    
    /// 加载大图
    ///
    /// - Parameter completion: 大图下载
    func loadLargeImage(_ completion: @escaping (_ flickrPhoto:FlickrPhoto, _ error: NSError?) -> Void) {
        
        // 拼接大图URL
        guard let loadURL = flickrImageURL("b") else {
            DispatchQueue.main.async {
                completion(self, nil)
            }
            return
        }
        
        let loadRequest = URLRequest(url: loadURL)
        
        URLSession.shared.dataTask(with: loadRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(self, error as NSError?)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(self, nil)
                }
                return
            }
            
            let returnedImage = UIImage(data: data)
            self.largeImage = returnedImage
            DispatchQueue.main.async {
                completion(self, nil)
            }
        }.resume()
    }
    
    /// 根据Size调整图片大小
    ///
    /// - Parameter size: 调整的size
    /// - Returns: 调整后的size
    func sizeToFillWidthOfSize(_ size: CGSize) -> CGSize {
        guard let thumbnail = thumbnail else {
            return size
        }
        
        let imageSize = thumbnail.size
        var returnSize = size
        
        // 按比例调整size
        let aspectRatio = imageSize.width / imageSize.height
        
        returnSize.height = returnSize.width / aspectRatio
        
        if returnSize.height > size.height {
            returnSize.height = size.height
            returnSize.width  = size.height * aspectRatio
        }
        
        return returnSize
    }
}

func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
    return lhs.photoID == rhs.photoID
}
