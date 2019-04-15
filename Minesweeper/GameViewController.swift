//
//  ViewController.swift
//  Minesweeper
//
//  Created by sapir kalbin on 25/03/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.

import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate{
    @IBOutlet weak var feedbackLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 0.0, right: 4.0);

    var gameDiff: GameDifficulty?
    var difficulty = ""
    var nickname = ""
    var board: Board?
    var minesToGo: Int = 5
    var gameEnd = false
    var seconds = 0
    var minutes = 0

    var timer = Timer()
    var isTimerRunning = false
    

    
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        if(sender.state == UIGestureRecognizer.State.began) {
            let touchPoint = sender.location(in: collectionView);
            guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { return; };
            
            if(board!.tiles[indexPath.count][indexPath.section].isMarked)
            {
                board?.tiles[indexPath.row][indexPath.section].isMarked = false
                (collectionView.cellForItem(at: indexPath) as? MyCell)?.label.text = String(board!.tiles[indexPath.row][indexPath.section].minesAround)
                minesToGo += 1
            }
            else
            {
                board?.tiles[indexPath.row][indexPath.section].isMarked = true
                (collectionView.cellForItem(at: indexPath) as? MyCell)?.label.text = "F"
                minesToGo -= 1
            }
            
            textView.text = "\(nickname), You have \(minesToGo) mines to go!"
            var modifiedCells = [IndexPath]();
            modifiedCells.append(indexPath);
            
            notifyDataSetChanged(collectionView: collectionView, indexPathArr: modifiedCells);
            
        }
    }
    
   
    func notifyDataSetChanged(collectionView: UICollectionView, indexPathArr: [IndexPath]) {
        collectionView.reloadItems(at: indexPathArr);
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer() {
        //hour worst case
        var secondsToDisplay: String
        var minutesToDisplay: String

        seconds += 1
        
        if(seconds>59)
        {
            minutes += 1
            seconds = 0
        }
        if(seconds<10)
        {
            secondsToDisplay = "0\(seconds)"
        }
        else
        {
            secondsToDisplay = "\(seconds)"
        }
        
        if(minutes<10)
        {
            minutesToDisplay = "0\(minutes)"
        }
        else
        {
            minutesToDisplay = "\(minutes)"

        }
        timerLbl.text = "\(minutesToDisplay):\(secondsToDisplay)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        
        gameDiff = getDiff()
        board = Board(difficulty: gameDiff!)
        minesToGo = gameDiff!.minesNumber
        textView.text = "\(nickname), You have \(minesToGo) mines to go!"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        performSegue(withIdentifier: "restartSegue", sender: self)
    }
    
    
    
    
    private func initMinesDebug()
    {
        guard let boards = board else {return}
        guard let diff = gameDiff else {return}
        
        for i in 0..<diff.size.height-1
        {
            for j in 0..<diff.size.width-1
            {
                if boards.tiles[i][j].isMine
                {
                    (collectionView.cellForItem(at: IndexPath(row: i, section: j)) as? MyCell)?.label.text = "X"
                }
            }
        }
    }
    
    private func revealAllBoard()
    {
        guard let boards = board else {return}
        guard let diff = gameDiff else {return}
        
        for i in 0..<diff.size.height
        {
            for j in 0..<diff.size.width
            {
                if boards.tiles[i][j].isMine
                {
                    (collectionView.cellForItem(at: IndexPath(row: i, section: j)) as? MyCell)?.label.text = "X"
                }
                else
                {
                    (collectionView.cellForItem(at: IndexPath(row: i, section: j)) as? MyCell)?.label.text = "\(boards.tiles[i][j].minesAround)"
                }
                
            }
        }
    }
    
    private func initNumbers()
    {
        guard let diff = gameDiff else {return}
        
        for i in 0..<diff.size.height
        {
            for j in 0..<diff.size.width
            {
                if !(board!.tiles[i][j].isMine)
                {
                    board!.tiles[i][j].minesAround = board!.getNumber(i: i, j: j)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //initMinesDebug()
        initNumbers()
        runTimer()
    }
    
    func getDiff() -> GameDifficulty
    {
        switch (difficulty) {
        case "easy":
            return GameDifficulty.Easy
        case "normal":
            return GameDifficulty.Normal
        case "hard":
            return GameDifficulty.Hard
        default:
            return GameDifficulty.Easy
        }
    }
    
    func revealArea(x: Int, y: Int)
    {
        guard let diff = gameDiff else {return}
        
        var startCol: Int
        var startRow: Int
        var endCol: Int
        var endRow: Int
        
        if x == 0
        {
            startRow = 0
        }
        else
        {
            startRow = x - 1
        }
        
        if y == 0
        {
            startCol = 0
        }
        else
        {
            startCol = y - 1
        }
        
        if y == diff.size.height-1
        {
            endRow = diff.size.height-1
        }
        else{
            endRow = y + 1
        }
        if(y == diff.size.width-1)
        {
            endCol = diff.size.width-1
        }
        else
        {
            endCol = y + 1
        }
        
        for i in startRow..<endRow+1
        {
            for j in startCol..<endCol+1
            {
                guard let boards = board else {return}

                (collectionView.cellForItem(at: IndexPath(row: i, section: j)) as? MyCell)?.label.text = String(describing: "\(boards.tiles[i][j].minesAround)")
                board?.tiles[i][j].isRevealed = true
                if board!.isGameWon
                {
                    gameWon()
                }
                if(board?.tiles[i][j].minesAround == 0)
                {
                    revealArea(x: i, y: j)
                }
            }
        }
    }
    
    func gameLose()
    {
    feedbackLbl.text = "YOU LOSE!"
    feedbackLbl.isHidden = false
    feedbackLbl.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
    revealAllBoard()
    timer.invalidate()
    }
    
    func gameWon()
    {
        feedbackLbl.text = "YOU WIN!"
        feedbackLbl.isHidden = false
        feedbackLbl.textColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
    }
}


extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameDiff!.size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameDiff!.size.width
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizeOfBoard = CGFloat(gameDiff!.size.height);
        //print("top: ", collectionView.adjustedContentInset.top);
        let paddingSpace = sectionInsets.left * (sizeOfBoard + 1);
        let availableWidth = collectionView.frame.width - paddingSpace;
        let cellWidth = availableWidth / sizeOfBoard;
        
        return CGSize(width: cellWidth, height: cellWidth);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //print("Width: ", collectionView.frame.width, " Height: ", collectionView.frame.height);
        return sectionInsets;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let boards = board else {return}
        
        if !gameEnd
        {
            if (boards.tiles[indexPath.row][indexPath.section].isMine)
            {
                gameLose()
            }
            else if(boards.tiles[indexPath.row][indexPath.section].minesAround == 0)
            {
                revealArea(x: indexPath.row, y: indexPath.section)
            }
            else
            {
                (collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: indexPath.section)) as? MyCell)?.label.text = "\(boards.tiles[indexPath.row][indexPath.section].minesAround)"
            }
            boards.tiles[indexPath.row][indexPath.section].isRevealed = true
            if board!.isGameWon
            {
                gameWon()
            }
        }
    }
    
}

class MyCell: UICollectionViewCell{
    @IBOutlet weak var label: UILabel!
    
    
}
