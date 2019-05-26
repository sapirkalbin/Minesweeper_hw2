//
//  Record.swift
//  Minesweeper
//
//  Created by Sapir Kalbin on 08/05/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import Foundation
import CoreLocation

class Record {
    var nickname: String
    var score: String
    var location: CLLocation
    var difficulty: String
    
    init(nickname: String, score: String, difficulty: String, location: CLLocation) {
        self.nickname = nickname
        self.score = score
        self.difficulty = difficulty
        self.location = location
    }
}
