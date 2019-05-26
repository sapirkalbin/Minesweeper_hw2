//
//  MineCell.swift
//  Minesweeper
//
//  Created by sapir kalbin on 10/04/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var mineCountLabel: UILabel!
    
    @IBOutlet weak var mineBackView: UIView!
    
    @IBOutlet weak var mineIcon: UIImageView!
    
    @IBOutlet weak var flagIcon: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.flagIcon.isHidden = true
        
        self.mineIcon.isHidden = true
        
        self.mineBackView.isHidden = true
        
        self.isSwept = false
        
        self.contentView.backgroundColor = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1)
        
    }
    
    var mineCount: Int = 0 {
        willSet {
            self.mineCountLabel.text = String(newValue)
            
        }
    }
    
    var isSwept = false {
        
        didSet {
            
            if self.mineCount > 0 {
                
                self.mineBackView.isHidden = !isSwept

            }
            else if self.mineCount == 0 {
                
                self.contentView.backgroundColor = .darkGray
                
                self.flagIcon.isHidden = true
                
            }
            
        }
        
    }
    
}
