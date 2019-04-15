//
//  DetailsViewController.swift
//  Minesweeper
//
//  Created by sapir kalbin on 09/04/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var errorTextView: UITextView!
    @IBAction func continueBtn(_ sender: Any) {
        if (nickNameField.text != "")
        {
            performSegue(withIdentifier: "nameSegue", sender: self)
        }
        else
        {
            errorTextView.text = "Nickname Should Not Be Empty."
        }
    }
    
    var nickname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var difficultyController = segue.destination as! DifficultyViewController
        difficultyController.nickname = nickNameField.text!
    }
}
