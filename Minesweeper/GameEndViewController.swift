//
//  GameEndViewController.swift
//  Minesweeper
//
//  Created by Sapir Kalbin on 08/05/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import UIKit

class GameEndViewController: UIViewController {
    @IBOutlet weak var newRecordText: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBAction func retry(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        self.present(detailsViewController, animated: true, completion: nil)
    }
    
    @IBAction func tableOfRecords(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let scoresViewController = storyBoard.instantiateViewController(withIdentifier: "ScoresViewController") as! ScoresViewController
        self.present(scoresViewController, animated: true, completion: nil)
    }
    
    var textMessage = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.moveRight(view: self.messageLbl)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageLbl.text = textMessage

    }
    
    func moveRight(view: UIView) {
        view.center.x += 300
    }
    
    func moveLeft(view: UIView) {
        view.center.x -= 300
    }
    
    func setMessage(string: String, newRecord: Bool)
    {
        textMessage = string
        newRecordText.isHidden = newRecord
    }
    
}
