//
//  Tile.swift
//  Minesweeper
//
//  Created by sapir kalbin on 01/04/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import Foundation

class Tile: Equatable {
    var x, y: Int
    var isMine: Bool
    var isRevealed: Bool
    var isMarked: Bool
    var minesAround: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.isMine = false
        self.isRevealed = false
        self.isMarked = false
        self.minesAround = 0
    }
    
    func setMine() ->Bool{
        if (!isMine)
        {
            isMine = true
            return true
        }
        return false
    }
    
}

func ==(lhs: Tile, rhs: Tile) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
