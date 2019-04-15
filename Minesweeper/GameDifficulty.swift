//
//  GameDifficulty.swift
//  Minesweeper
//
//  Created by sapir kalbin on 01/04/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import Foundation

enum GameDifficulty: String {
    case Easy, Normal, Hard
    
    var size: (width: Int, height: Int) {
        switch self {
        case .Easy:
            return (5, 5)
        case .Normal:
            return (10, 10)
        case .Hard:
            return (10, 10)
        }
    }
    
    var minesNumber: Int {
        switch self {
        case .Easy:
            return 10
        case .Normal:
            return 20
        case .Hard:
            return 30
        }
    }
    
}
