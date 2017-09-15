//
//  Helper.swift
//  Birthdays
//
//  Created by pike young on 2017/9/13.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class Helper {
    
    /// 提示弹窗
    ///
    /// - Parameter message: 显示的消息
    static func show(message: String) {
        let alertController = UIAlertController(title: "Birthdays", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(dismissAction)
        
        let pushedViewControllers = (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers.last
        
        presentedViewController?.present(alertController, animated: true, completion: nil)
    }
}


extension DateComponents {
    
    /// 转换日期为字符串
    var asString: String? {
        if let date = Calendar.current.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = .medium
            let dateString = dateFormatter.string(from: date)
            
            return dateString
        }
        
        return nil
    }
}
