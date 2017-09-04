//
//  HTTPClient.swift
//  BlueLibrarySwift
//
//  Created by pike young on 2017/9/1.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class HTTPClient {
    
    func getRequest(_ url: String) -> (AnyObject) {
        return Data() as (AnyObject)
    }
    
    func postRequest(_ url: String, body: String) -> (AnyObject) {
        return Data() as (AnyObject)
    }
    
    // This is synchronous way to download image via url, please use it in background
    func downloadImage(_ url: String) -> (UIImage) {
        let aUrl = URL(string: url)
        
        guard let data = try? Data(contentsOf: aUrl!) else {
            return UIImage()
        }
        
        let image = UIImage(data: data)
        return image!
    }
}
