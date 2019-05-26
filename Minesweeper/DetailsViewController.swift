//
//  DetailsViewController.swift
//  Minesweeper
//
//  Created by sapir kalbin on 09/04/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var myView: UIView!

    @IBAction func editingChanged(_ sender: Any) {
        errorLbl.text = ""
    }
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var nickNameField: UITextField!


    @IBAction func continueBtn(_ sender: Any) {
        guard let nickname = nickNameField.text else { return;}
        
        if (!nickname.isEmpty)
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let diffViewController = storyBoard.instantiateViewController(withIdentifier: "DifficultyViewController") as! DifficultyViewController;
            diffViewController.setNickname(nickname: nickname)
            self.present(diffViewController, animated: true, completion: nil);
        }
        else
        {
            errorLbl.text = "Nickname Should Not Be Empty."
            return;
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.setGradientBackground(colorOne: Colors.red, colorTwo: Colors.orange)

    }
    
}
