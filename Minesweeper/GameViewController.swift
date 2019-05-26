//
//  ViewController.swift
//  Minesweeper
//
//  Created by sapir kalbin on 25/03/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.

import CoreLocation
import UIKit
import Firebase

class GameViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    @IBOutlet weak var minesColletcionView: UICollectionView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    var ref: DatabaseReference!

    var difficultySize = 10
    var totlaMinesNumber = 0
    var minesNumber = 10
    var minesToGo = 10
    var nickname = ""
    var diff = ""
    var myTimer = Timer()
    var finishGameTimer = Timer()
    var scoresArray: [Record] = []
    var seconds = 0
    var minutes = 0
    var minesweeperArray: [[Int]]!
    var longest: Record!
    var gameEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getScoresByDiff(difficulty: diff)

        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.createNewGame()
        
        self.addLongPressGesture()
        
        runTimer()
        
        textLbl.text = "\(nickname), You have \(minesToGo) mines to go!"
    }
    
    func getScoresByDiff(difficulty: String) {
    ref.child("scores").observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        
        if snapshot.exists() {
            let array:NSArray = snapshot.children.allObjects as NSArray
            
            for child in array {
                let snap = child as! DataSnapshot
                if(snap.key as String == difficulty){
                    if snap.value is NSArray {
                        let data:NSArray = snap.value as! NSArray
                        for i in 0...data.count - 1{
                            let dictionary = data[i] as! NSDictionary
                            let nickname: String = dictionary.value(forKey: "name") as! String
                            let score: String = dictionary.value(forKey: "score") as! String
                            
                            self.scoresArray.append(Record(nickname: nickname, score: score, difficulty: difficulty, location:CLLocation()))
                        }
                    }
                }
            }
        }

    }) { (error) in
        print(error.localizedDescription)
    }
}
    
    func checkIsHighscore() -> Bool {
    if(scoresArray.count <= 10) {
        return true
    }
    else {
        self.longest = getLowestScore()
        
        let longestArr = longest.score.split{$0 == ":"}.map(String.init)
        let min_l = Int(longestArr[0])!
        let sec_l = Int(longestArr[1])!
        
        if(self.minutes < min_l){
            return true
        }
        else if (self.minutes == min_l) {
            if(self.seconds < sec_l) {
                return true
            }
        }
        return false
        }
    }
    
    func getLowestScore() -> Record {
        var longest: Record
        longest = scoresArray[0]
        
        for score in self.scoresArray{
            let scoreArr = score.score.split{$0 == ":"}.map(String.init)
            var longestArr = longest.score.split{$0 == ":"}.map(String.init)

            let min_l: String = longestArr[0]
            let sec_l: String = longestArr[1]
            let min_cur: String = scoreArr[0]
            let sec_cur: String = scoreArr[1]

            if(Int(min_l)! < Int(min_cur)!){
                longest = score
            }
            else if (Int(min_l)! == Int(min_cur)!)
            {
                if(Int(sec_l)! < Int(sec_cur)!){
                    longest = score
                }
            }
        }
        return longest
    }
    
    func runTimer() {
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func FinishGameTimer() {
        myTimer.invalidate()
        gameEnd = true
        finishGameTimer = Timer.scheduledTimer(timeInterval: 2, target: self,   selector: (#selector(self.finishGame)), userInfo: nil, repeats: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    @objc func finishGame() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let gameEndViewController = storyBoard.instantiateViewController(withIdentifier: "GameEndViewController") as! GameEndViewController;
        gameEndViewController.setMessage(string: "You Lose!", newRecord: false)
        finishGameTimer.invalidate()
        self.present(gameEndViewController, animated: true, completion: nil);
    }
    
    @objc func updateTimer() {
        //hour worst case
        guard let timer = timerLbl else {return}
        var secondsToDisplay = String(seconds)
        var minutesToDisplay = String(minutes)
        
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
        timer.text = "\(minutesToDisplay):\(secondsToDisplay)"
    }
    
    
    func setDetails(nickname: String, difficulty: GameDifficulty) {
        self.minesToGo = difficulty.minesNumber
        self.difficultySize = difficulty.size
        self.diff = difficulty.name
        self.minesNumber = difficulty.minesNumber
        self.nickname = nickname
    }
    
    private func createNewGame() {
        self.setMines()
        
    }
    
    private func setMines() {
        self.totlaMinesNumber = minesNumber
        
        minesweeperArray  = createZeroArray(with: difficultySize)
        
        while minesNumber > 0 {
            
            var coordinate = randomMineCoordinate()
            
            while minesweeperArray[coordinate.0][coordinate.1] == -1 {
                
                coordinate = randomMineCoordinate()
            }
            
            minesweeperArray[coordinate.0][coordinate.1] = -1
            
            minesNumber -= 1
            
        }
        
        for rowIndex in 0 ..< minesweeperArray.count {
            
            for columnIndex in  0 ..< minesweeperArray[rowIndex].count {
                
                if minesweeperArray[rowIndex][columnIndex] == 0 {
                    
                    let sum = summaryMine(row: rowIndex, column: columnIndex)
                    
                    minesweeperArray[rowIndex][columnIndex] = sum
                    
                }
                
            }
            
        }
                print()
        for rowIndex in 0..<minesweeperArray.count
        {
            for columnIndex in  0..<minesweeperArray[ rowIndex ].count
            {
                let v = minesweeperArray[ rowIndex ][ columnIndex ]
                print("\(v>=0 ? " ":"")\(v) " , terminator:"")
            }
            print()
        }
        print()
    }
    
    private func addLongPressGesture() {
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        
        self.minesColletcionView.addGestureRecognizer(gesture)
        
    }
    
    private func createZeroArray(with dimesional: Int) -> [[Int]] {
        
        let zeroArray = Array(repeating: Array(repeating: 0, count: dimesional), count: dimesional)
        
        return zeroArray
        
    }
    
    private func randomMineCoordinate() -> (Int,Int) {
        
        let column = Int.random(in: 0 ..< difficultySize)
        
        let row = Int.random(in: 0 ..< difficultySize)
        
        return (column, row)
        
    }
    
    private func summaryMine(row: Int, column: Int ) -> Int {
        
        var mineCount = 0
        
        let leftTop = (row - 1, column - 1)
        let top = (row - 1, column)
        let rightTop = (row - 1, column + 1)
        
        let left = (row, column - 1)
        let right = (row, column + 1)
        
        let leftDown = (row + 1, column - 1)
        let down = (row + 1, column)
        let rightDown = (row + 1, column + 1)
        
        let eightPositions = [leftTop, top, rightTop, left, right, leftDown, down, rightDown]
        
        for (row, column) in eightPositions {
            
            if row >= 0 && row < difficultySize
                && column >= 0 && column < difficultySize {
                
                if minesweeperArray[row][column] == -1 {
                    
                    mineCount += 1
                    
                }
                
            }
            
        }
        
        return mineCount
        
    }
    
    func removeLowestHighscore(){
    
    }
    
    func addNewHighscore (){
        self.ref.child("scores").child(diff).setValue(Record(nickname: nickname, score: timerLbl.text!, difficulty: diff, location: CLLocation()))
        ResultsPage(isHighscore: true)
    }

    
    func revealBoard() {
        
    }
    
    func ResultsPage(isHighscore: Bool) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let gameEndViewController = storyBoard.instantiateViewController(withIdentifier: "GameEndViewController") as! GameEndViewController;
        gameEndViewController.setMessage(string: "You Win!", newRecord: isHighscore)
        self.present(gameEndViewController, animated: true, completion: nil);
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.difficultySize * self.difficultySize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCell {
            
            let row = indexPath.row / self.difficultySize
            
            let column = indexPath.row - (self.difficultySize * row)
            
            cell.mineCount = self.minesweeperArray[row][column]
            
            // add a border
            cell.layer.borderColor = UIColor.black.cgColor
            
            cell.layer.borderWidth = 1
            
            cell.backgroundColor = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1)
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.width / CGFloat(difficultySize)
        
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        
        return cellSize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}


extension GameViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(!gameEnd)
        {
        let tapCoordinate = Coordinate(indexPath: indexPath, globalDimesional: self.difficultySize)
        
        let mineCount = self.minesweeperArray[tapCoordinate.row!][tapCoordinate.column!]
        
        
        
        if mineCount >= 0 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCell else { return }
            
            if !cell.flagIcon.isHidden
            {
                minesToGo += 1
                textLbl.text = "\(nickname), You have \(minesToGo) mines to go!"
            }
            
            self.mineSweep(collectionView, coordinate: tapCoordinate)
            
            self.checkSweep()
            
            return
            
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCell else { return }

        cell.mineIcon.isHidden = false
        
        FinishGameTimer()
        }
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        
        if gesture.state == .ended { return }
        
        if gesture.state == .cancelled { return }
        
        if gesture.state == .changed { return }
        
        let p = gesture.location(in: self.minesColletcionView)
        
        if let indexPath = self.minesColletcionView.indexPathForItem(at: p) {
            
            guard let cell = self.minesColletcionView.cellForItem(at: indexPath) as? CustomCell else { return }
            
            if !cell.isSwept {
                if(minesToGo > 0)
                {
                cell.flagIcon.isHidden.toggle()
                if(cell.flagIcon.isHidden)
                {
                    minesToGo += 1
                }
                else
                {
                    minesToGo -= 1
                }
                
                textLbl.text = "\(nickname), You have \(minesToGo) mines to go!"
                }
            }
            
        }
        
    }

}

extension GameViewController {
    
    private func mineSweep(_ collectionView: UICollectionView, coordinate: Coordinate, fromIndexPath: IndexPath? = nil) {
        
        guard let cell = collectionView.cellForItem(at: coordinate.indexPath!) as? CustomCell else { return }
        
        guard cell.isSwept == false else { return }
        
        guard let row = coordinate.row,
            0 ..< self.difficultySize ~= row else { return }
        
        guard let column = coordinate.column,
            0 ..< self.difficultySize ~= column else { return }
        
        cell.isSwept.toggle()
        
        let myMineCount = self.minesweeperArray[row][column]
        
        if myMineCount > 0 { return }
        
        if myMineCount == 0 {
            
            cell.layer.borderWidth = 0
            
            cell.mineBackView.backgroundColor = .darkGray
            
        }
        
        let leftTop = Coordinate(row: row - 1, column: column - 1, globalDimesional: self.difficultySize)
        
        let top = Coordinate(row: row - 1, column: column, globalDimesional: self.difficultySize)
        
        let rightTop = Coordinate(row: row - 1, column: column + 1, globalDimesional: self.difficultySize)
        
        let left = Coordinate(row: row, column: column - 1, globalDimesional: self.difficultySize)
        
        let right = Coordinate(row: row, column: column + 1, globalDimesional: self.difficultySize)
        
        let leftBottom = Coordinate(row: row + 1, column: column - 1, globalDimesional: self.difficultySize)
        
        let bottom = Coordinate(row: row + 1, column: column, globalDimesional: self.difficultySize)
        
        let rightBottom = Coordinate(row: row + 1, column: column + 1, globalDimesional: self.difficultySize)
        
        let surroundCoordinates = [leftTop, top, rightTop, left, right, leftBottom, bottom, rightBottom]
        
        if let fromIndexPath = fromIndexPath {
            
            let fromCoordinate = Coordinate(indexPath: fromIndexPath, globalDimesional: self.difficultySize)
            
            for surroundCoordinate in surroundCoordinates {
                
                if surroundCoordinate == fromCoordinate {
                    
                    continue
                    
                }
                
                self.mineSweep(collectionView, coordinate: surroundCoordinate, fromIndexPath: coordinate.indexPath!)
                
            }
            
        }
        else {
            
            for surroundCoordinate in surroundCoordinates {
                
                self.mineSweep(collectionView, coordinate: surroundCoordinate, fromIndexPath: coordinate.indexPath!)
                
            }
            
        }
        
    }
    
    func checkSweep() {
        
        var sweptCount = 0
        
        let indexPaths = self.minesColletcionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            
            guard let cell = self.minesColletcionView.cellForItem(at: indexPath) as? CustomCell else { return }
            
            if cell.isSwept {
                
                sweptCount += 1
                
            }
            
        }
        
        let isOverCount = (difficultySize * difficultySize) - self.totlaMinesNumber
        
        if sweptCount == isOverCount {
            let score = "\(minutes).\(seconds)"
            
            let defaults = UserDefaults.standard
            if let numOfRecords = defaults.string(forKey: "numOfRecords") {
                defaults.set(Int(numOfRecords)! + 1, forKey: "numOfRecords")
                defaults.set("\(score)|\(Int(numOfRecords)! + 1)", forKey: "record\(Int(numOfRecords)! + 1)")
            }
            else
            {
                defaults.set("1", forKey: "numOfRecords")
                defaults.set("score|name", forKey: "record1")
            }
            
            if(self.checkIsHighscore()) {
                removeLowestHighscore()
                addNewHighscore()
                
            }
            else {
                ResultsPage(isHighscore: false)
            }
        }
    }
    
    struct Coordinate: Equatable {
        
        var row: Int?
        
        var column: Int?
        
        var indexPath: IndexPath?
        
        init(indexPath: IndexPath, globalDimesional: Int) {
            
            self.row = indexPath.row / globalDimesional
            
            self.column = indexPath.row - (globalDimesional * self.row!)
            
            self.indexPath = indexPath
            
        }
        
        init(row: Int, column: Int, globalDimesional: Int) {
            
            self.row = row
            
            self.column = column
            
            self.indexPath = IndexPath(row: row * globalDimesional + column, section: 0)
            
        }
        
    }
    
}
