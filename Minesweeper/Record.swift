//
//  Record.swift
//  Minesweeper
//
//  Created by Sapir Kalbin on 08/05/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import Foundation

class Record {
    var nickname: String
    var score: String
    var location: String
    var difficulty: String
    
    init(nickname: String, score: String, difficulty: String, location: String) {
        self.nickname = nickname
        self.score = score
        self.difficulty = difficulty
        self.location = location
    }
}
