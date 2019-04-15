//
//  DifficultyViewController.swift
//  Minesweeper
//
//  Created by sapir kalbin on 09/04/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {
    var difficulty = ""
    var nickname = ""
    
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var normalBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    @IBAction func startGame(_ sender: Any) {
        if(difficulty != "")
        {
            performSegue(withIdentifier: "diffSegue", sender: self)
        }
    }
    @IBAction func easyClick(_ sender: Any) {
        difficulty = "easy"
        easyBtn.backgroundColor = UIColor(red: 0, green: 112, blue: 211, alpha: 1)
        normalBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1)
        hardBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1)
    }
    @IBAction func normalClick(_ sender: Any) {
        difficulty = "normal"
        easyBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1)
        normalBtn.backgroundColor = UIColor(red: 0, green: 112, blue: 211, alpha: 1)
        hardBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1)
    }
    @IBAction func hardClick(_ sender: Any) {
        difficulty = "hard"
        easyBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1)
        normalBtn.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1)
        hardBtn.backgroundColor = UIColor(red: 0, green: 112, blue: 211, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameController = segue.destination as! GameViewController
        gameController.nickname = nickname
        gameController.difficulty = difficulty
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
