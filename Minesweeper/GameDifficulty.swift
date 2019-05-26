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
    
    var name: String {
        switch self {
        case .Easy:
            return "easy"
        case .Normal:
            return "normal"
        case .Hard:
            return "hard"
        }
    }
    
    var size: Int {
        switch self {
        case .Easy:
            return 5
        case .Normal:
            return 10
        case .Hard:
            return 10
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
