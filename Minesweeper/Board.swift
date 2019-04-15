//
//  Board.swift
//  Minesweeper
//
//  Created by sapir kalbin on 29/03/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import Foundation


class Board {
    let difficulty: GameDifficulty
    
    var minesInitialized: Bool
    var gameOver: Bool
    
    //   var startDate: Date?
    //    var score: TimeInterval?
    
    var tiles: [[Tile]]
    var mines: [Tile] = []
    
    var height: Int {
        return difficulty.size.height
    }
    
    var width: Int {
        return difficulty.size.width
    }
    
    var minesNumber: Int {
        return difficulty.minesNumber
    }
    
    var isGameWon: Bool {
        for i in 0..<width {
            for j in 0..<height {
                if !tiles[i][j].isRevealed && !tiles[i][j].isMine {
                    return false
                }
            }
        }
        
        return true
    }
    
    init(difficulty: GameDifficulty) {
        self.difficulty = difficulty
        
        //        // Score purpose
        //        self.score = nil
        //        self.startDate = nil
        //
        minesInitialized = false
        gameOver = false
        
        tiles = [[Tile]](repeating: [Tile](repeating: Tile(x: 0, y: 0), count: difficulty.size.height), count: difficulty.size.width)
        
        for x in 0..<height{
            for y in 0..<width {
                self.tiles[x][y] = Tile(x: x, y: y)
            }
        }
        
        initMines()
        
    }
    
    func getNumber(i: Int, j: Int) -> Int
    {
        var counter: Int = 0
        var startCol: Int
        var startRow: Int
        var endCol: Int
        var endRow: Int
        
        if i == 0
        {
            startRow = 0
        }
        else
        {
            startRow = i - 1
        }
        
        if j == 0
        {
            startCol = 0
        }
        else
        {
            startCol = j - 1
        }
        
        if i == height-1
        {
            endRow = height-1
        }
        else{
            endRow = i + 1
        }
        if(j == width-1)
        {
            endCol = width-1
        }
        else
        {
            endCol = j + 1
        }
        
        for x in startRow..<endRow+1
        {
            for y in startCol..<endCol+1
            {
                if(tiles[x][y].isMine)
                {
                    counter = counter + 1
                }
            }
        }
        
        return counter
        
    }
    
    private func initMines()
    {
        for _ in 0..<minesNumber{
            var height = Int(arc4random_uniform(UInt32(self.height-1)))
            var width = Int(arc4random_uniform(UInt32(self.width-1)))
            
            while !(tiles[height][width].setMine())
            {
                height = Int(arc4random_uniform(UInt32(self.height-1)))
                width = Int(arc4random_uniform(UInt32(self.width-1)))
            }
            mines.append(Tile(x: height, y: width))
        }
    }
    
    
}
