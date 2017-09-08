//
//  Flickr.swift
//  FlickrSearch
//
//  Created by pike young on 2017/9/6.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

// 获取图片的URL地址
// go to https://www.flickr.com/services/api/explore/flickr.photos.getRecent to get the latest apikey
let apiKey = "4fd0b392ff804cce1e837a776c50eac2"

class Flickr {
    
    let processingQueue = OperationQueue()
    
    
    /// 根据文字搜索相关图片
    ///
    /// - Parameters:
    ///   - searchTerm: 文字
    ///   - completion: 完成回调
    func searchFlickrForTerm(_ searchTerm: String, completion : @escaping (_ results: FlickrSearchResults?, _ error: NSError?) -> Void) {
        
        // 是否有效URL
        guard let searchURL = flickrSearchURLForSearchTerm(searchTerm) else {
            let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey : "Unknown API response"])
            completion(nil, APIError)
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: searchRequest) { (data, response, error) in
            if let _ = error {
                let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                OperationQueue.main.addOperation({
                    completion(nil, APIError)
                })
                return
            }
            
            guard let _ = response as? HTTPURLResponse, let data = data else {
                let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                OperationQueue.main.addOperation {
                    completion(nil, APIError)
                }
                return
            }
            
            do {
                // 解析json数据，看看返回格式是否正确
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject], let stat = resultsDictionary["stat"] as? String else {
                    
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation {
                        completion(nil, APIError)
                    }
                    return
                }
                
                switch (stat) {
                    case "ok":
                        print("Results processed OK")
                    case "fail":
                        if let message = resultsDictionary["message"] {
                            let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:message])
                            
                            OperationQueue.main.addOperation {
                                completion(nil, APIError)
                            }
                        }
                    
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: nil)
                    
                        OperationQueue.main.addOperation {
                            completion(nil, APIError)
                        }
                        return
                    default:
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                        return
                }
                
                guard let photosContainer = resultsDictionary["photos"] as? [String : AnyObject], let photosReceived = photosContainer["photo"] as? [[String: AnyObject]] else {
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
                }
                
                var flickrPhotos = [FlickrPhoto]()
                
                for photoObject in photosReceived {
                    guard let photoID = photoObject["id"] as? String,
                        let farm = photoObject["farm"] as? Int ,
                        let server = photoObject["server"] as? String ,
                        let secret = photoObject["secret"] as? String else {
                            break
                    }
                    let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
                    
                    // 根据图片信息，拼接图片URL
                    guard let url = flickrPhoto.flickrImageURL(), let imageData = try? Data(contentsOf: url as URL) else {
                        break
                    }
                    
                    if let image = UIImage(data: imageData) {
                        flickrPhoto.thumbnail = image
                        flickrPhotos.append(flickrPhoto)
                    }
                }
                
                OperationQueue.main.addOperation {
                    completion(FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos), nil)
                }
                
            } catch _ {
                completion(nil, nil)
                return
            }
        }.resume()
    }
    
    /// 拼接URL
    ///
    /// - Parameter searchTerm: 文本
    /// - Returns: 拼接完成的URL
    fileprivate func flickrSearchURLForSearchTerm(_ searchTerm: String) -> URL? {
        
        // 搜索文本只包含字母和数字
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&extras=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        
        guard let url = URL(string: URLString) else {
            return nil
        }
        
        return url
    }
}
