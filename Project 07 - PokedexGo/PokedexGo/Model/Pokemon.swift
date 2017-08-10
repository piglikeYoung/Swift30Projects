//
//  Pokemon.swift
//  PokedexGo
//
//  Created by pike young on 2017/8/9.
//  Copyright © 2017年 pike young. All rights reserved.
//

import Foundation

enum PokeType {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
}

struct Pokemon {
    let name: String
    let id: Int
    let detailInfo: String
    let type: [PokeType]
    let weak: [PokeType]
    let pokeImgUrl: String
    
    init(name: String, id: Int, detailInfo: String, type: [PokeType], weak: [PokeType], pokeImgUrl: String) {
        self.name = name
        self.id = id
        self.detailInfo = detailInfo
        self.type = type
        self.weak = weak
        self.pokeImgUrl = pokeImgUrl
    }
}
