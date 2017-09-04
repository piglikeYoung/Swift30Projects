//
//  AlbumExtensions.swift
//  BlueLibrarySwift
//
//  Created by pike young on 2017/9/1.
//  Copyright © 2017年 pike young. All rights reserved.
//

import Foundation

extension Album {
    func ae_tableRepresentation() -> (titles:[String], values:[String]) {
        return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
}
