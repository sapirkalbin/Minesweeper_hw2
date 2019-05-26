//
//  DifficultyViewController.swift
//  Minesweeper
//
//  Created by sapir kalbin on 09/04/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {
    var difficulty = GameDifficulty.Easy
    var nickname = ""
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var normalBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    @IBAction func startGame(_ sender: Any) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let gameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            gameViewController.setDetails(nickname: nickname, difficulty: difficulty)
            self.present(gameViewController, animated: true, completion: nil)
    }
    @IBAction func easyClick(_ sender: Any) {
        difficulty = GameDifficulty.Easy
        easyBtn.backgroundColor = UIColor(red: 255, green: 255, blue: 153, alpha: 1)
        normalBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 0)
        hardBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 0)
    }
    @IBAction func normalClick(_ sender: Any) {
        difficulty = GameDifficulty.Normal
        easyBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 0)
        normalBtn.backgroundColor = UIColor(red: 255, green: 255, blue: 153, alpha: 1)
        hardBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 0)
    }
    @IBAction func hardClick(_ sender: Any) {
        difficulty = GameDifficulty.Hard
        easyBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 0)
        normalBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 0)
        hardBtn.backgroundColor = UIColor(red: 255, green: 255, blue: 153, alpha: 1)
    }
    
    func setNickname(nickname: String) {
        self.nickname = nickname
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.setGradientBackground(colorOne: Colors.red, colorTwo: Colors.orange)

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
